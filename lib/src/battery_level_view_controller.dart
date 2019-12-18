part of batterylevel;

class BatteryLevelViewController {
  StreamController _flutterToEvaluteStream;
  MethodChannel _batteryViewChannel;
  EventChannel _batteryViewEventChannel;
  StreamSubscription _eventSinkStreamSubscription;

  BatteryLevelViewController(
      {@required int viewId, StreamController flutterToEvaluteStream})
      : _batteryViewChannel =
            MethodChannel("flutter.io/batterylevel_view_$viewId"),
        _batteryViewEventChannel =
            EventChannel('flutter.io/batterylevel_view_event_$viewId'),
        _flutterToEvaluteStream = flutterToEvaluteStream;

  Future<void> sendMessageToNatvie(String message) async {
    return await _batteryViewChannel.invokeMethod('nativeToEvalute', message);
  }

  void bindNativeMethodCallBackHandler() {
    _batteryViewChannel.setMethodCallHandler(_handler);
  }

  Future<dynamic> _handler(MethodCall call) async {
    switch (call.method) {
      case "flutterToEvalute":
        _flutterToEvaluteStream.sink.add(call.arguments);
        break;
      default:
    }
  }

  Future<void> listentNativeContinuesEvents() async {
    _eventSinkStreamSubscription = _batteryViewEventChannel
        .receiveBroadcastStream("eventSink2")
        .cast<String>()
        .listen((data) {
      _flutterToEvaluteStream.sink.add(data);
    });
    return Future.value();
  }
}

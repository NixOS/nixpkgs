{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "wpkelso";
  name = "milk-tea";
  version = "0.0.2";
  hash = "sha256-PERWKCqyUOLAMKJI3fESCY/1gQ/hbsBoySMOQPX088M=";
  meta = {
    description = "Theme based around milk tea in its many forms";
    homepage = "https://plugins.lapce.dev/plugins/wpkelso/milk-tea";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

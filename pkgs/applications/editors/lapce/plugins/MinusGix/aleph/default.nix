{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "MinusGix";
  name = "aleph";
  version = "0.3.2";
  hash = "sha256-ByXVdX0MVZJFN74uWecFgh/BZL6F90OeWdH75RAC17A=";
  meta = {
    description = "Dark and colorful theme";
    homepage = "https://plugins.lapce.dev/plugins/MinusGix/aleph";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

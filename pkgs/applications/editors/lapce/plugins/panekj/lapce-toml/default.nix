{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "panekj";
  name = "lapce-toml";
  version = "0.0.0";
  hash = "sha256-hSXo5d7DuresKfN8lDlC8SCJ/+NeWZcAH8Xbp3kUwNc=";
  meta = {
    description = "TOML for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/panekj/lapce-toml";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

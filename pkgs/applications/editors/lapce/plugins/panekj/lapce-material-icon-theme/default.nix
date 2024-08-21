{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "panekj";
  name = "lapce-material-icon-theme";
  version = "0.0.1-beta1";
  hash = "sha256-rdnghlwYJy+oE7Fp76LuO+6bIUcYYJzxiJA8kLFKLbE=";
  meta = {
    description = "Material icon theme for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/panekj/lapce-material-icon-theme";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

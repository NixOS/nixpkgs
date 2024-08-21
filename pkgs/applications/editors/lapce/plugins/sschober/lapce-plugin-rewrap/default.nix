{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "sschober";
  name = "lapce-plugin-rewrap";
  version = "0.0.1";
  hash = "sha256-GgQ0479WQeMgcSYP7Os/JqMiX1AvHwNIfjEsxSfZHEc=";
  meta = {
    description = "Lapce plugin for rewrapping text at defined column widths.";
    homepage = "https://plugins.lapce.dev/plugins/sschober/lapce-plugin-rewrap";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

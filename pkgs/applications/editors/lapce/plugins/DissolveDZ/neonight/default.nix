{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "DissolveDZ";
  name = "neonight";
  version = "0.1.0";
  hash = "sha256-QKnf0zXbbLG8yTkGNJXoYemY521Fjr/hMTYSVYQywP0=";
  meta = {
    description = "A modern dark theme made specifically for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/DissolveDZ/neonight";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

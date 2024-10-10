{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "SimY4";
  name = "alabaster-theme";
  version = "0.1.0";
  hash = "sha256-J6OKBYixnNf/BBUlZvk14RZFDUgjA6SQ/GoJ5FJO4bs=";
  meta = {
    description = "Tonsky's Alabaster theme for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/SimY4/alabaster-theme";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

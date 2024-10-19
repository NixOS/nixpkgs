{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "c-sleuth";
  name = "pastel-collection-lapce";
  version = "0.1.0";
  hash = "sha256-wtODtc/oAxBB1wH5uQ4c/8g/Awa8kVDlvfxeRwcYUvs=";
  meta = {
    description = "A collection of pastel themes for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/c-sleuth/pastel-collection-lapce";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

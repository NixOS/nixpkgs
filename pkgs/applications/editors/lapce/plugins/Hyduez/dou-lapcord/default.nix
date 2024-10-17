{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "Hyduez";
  name = "dou-lapcord";
  version = "2.1.3";
  hash = "sha256-Rze956JhxnuArJIUjDplzT/k8ThxK/ESSpGBQqcPiC4=";
  meta = {
    description = "Discord Rich Presence extension for Lapce.";
    homepage = "https://plugins.lapce.dev/plugins/Hyduez/dou-lapcord";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

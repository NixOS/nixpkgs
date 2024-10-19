{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "akhildevelops";
  name = "lapce-python-nouse";
  version = "0.4.0";
  hash = "sha256-Acm9iMOMFCusvzY/BwIMxIFTwnD/EW3eomVrE7I6qdk=";
  meta = {
    description = "Don't use this plugin, use https://plugins.lapce.dev/plugins/superlou/lapce-python";
    homepage = "https://plugins.lapce.dev/plugins/akhildevelops/lapce-python-nouse";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

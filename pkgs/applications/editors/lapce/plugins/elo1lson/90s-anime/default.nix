{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "elo1lson";
  name = "90s-anime";
  version = "0.1.0";
  hash = "sha256-XDpidaJY3yAQEJ0IjjW9OZFKLWPt5Hn71A7SX3r+110=";
  meta = {
    description = "A tasteful but still practical colorful theme for Lapce. Great for purple color lovers <3.";
    homepage = "https://plugins.lapce.dev/plugins/elo1lson/90s-anime";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

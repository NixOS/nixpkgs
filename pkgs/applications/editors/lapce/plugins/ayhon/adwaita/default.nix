{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ayhon";
  name = "adwaita";
  version = "0.1.0";
  hash = "sha256-V6KKc506Iy+AyTbgUhcyoS/oRqWYK14FN+D0VenZuD4=";
  meta = {
    description = "Adwaita colors for GNOME";
    homepage = "https://plugins.lapce.dev/plugins/ayhon/adwaita";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

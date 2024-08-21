{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "Jalkhov";
  name = "marge";
  version = "0.1.0";
  hash = "sha256-5BlX4GeqDUdnPVqBjTIRCKaHw/LY9mefLghFKzoIIxs=";
  meta = {
    description = "A soft theme inspired in Mariana from Sublime Text 4";
    homepage = "https://plugins.lapce.dev/plugins/Jalkhov/marge";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

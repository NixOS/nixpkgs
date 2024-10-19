{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "Stanislav-Lapata";
  name = "lapce-angular";
  version = "0.1.0";
  hash = "sha256-0LgJZr/2FxxK9Ys3QXojhAYU3hnaZOzW0RgZvA3Pago=";
  meta = {
    description = "Angular plugin for the Lapce Editor - Powered by angular";
    homepage = "https://plugins.lapce.dev/plugins/Stanislav-Lapata/lapce-angular";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

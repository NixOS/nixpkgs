{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "hangj";
  name = "lapce-plugin-all-in-one";
  version = "0.1.0";
  hash = "sha256-swiW0j4f6hfnC4dHL+dImfmU0AmY1rjxIIbEaanoc40=";
  meta = {
    description = "hangj's personal plugin for lapce";
    homepage = "https://plugins.lapce.dev/plugins/hangj/lapce-plugin-all-in-one";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

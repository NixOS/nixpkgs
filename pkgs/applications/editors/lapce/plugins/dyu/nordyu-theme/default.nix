{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "dyu";
  name = "nordyu-theme";
  version = "0.1.0";
  hash = "sha256-E+bP2ZlUcBZDmOK7vQSGuLMGV1pzl6Zt4jdTuwsI83A=";
  meta = {
    description = "Nord-based color scheme.";
    homepage = "https://plugins.lapce.dev/plugins/dyu/nordyu-theme";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

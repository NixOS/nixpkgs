{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ghishadow";
  name = "catppuccin";
  version = "0.1.18";
  hash = "sha256-0J/35D2Vf/TAwpl/hEq0TThikzJWF0yYQd/XrIj+xDo=";
  meta = {
    description = "🐭 Soothing pastel theme for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/ghishadow/catppuccin";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

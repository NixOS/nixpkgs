{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ghishadow";
  name = "tokyo-night";
  version = "0.2.0";
  hash = "sha256-JTHsKph1tdHMH0jG9+hzJ+iEtXhQWH42H3CD8ih5e+A=";
  meta = {
    description = "A clean, dark Lapce theme that celebrates the lights of Downtown Tokyo at night.";
    homepage = "https://plugins.lapce.dev/plugins/ghishadow/tokyo-night";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

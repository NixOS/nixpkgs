{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ghishadow";
  name = "rose-pine";
  version = "0.2.6";
  hash = "sha256-V3F+JD5qXA1isT11yHtWZ6vIQx0h7VJaVGrIXL6CGnM=";
  meta = {
    description = "Soho vibes for Lapce";
    homepage = "https://plugins.lapce.dev/plugins/ghishadow/rose-pine";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

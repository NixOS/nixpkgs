{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ghishadow";
  name = "lapce-zig";
  version = "0.1.1";
  hash = "sha256-VIqEOoeti283CbdNP+IreRW19lNey5QVWWUWNhclAhU=";
  meta = {
    description = "Zig for Lapce: powered by Zig Language Server";
    homepage = "https://plugins.lapce.dev/plugins/ghishadow/lapce-zig";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

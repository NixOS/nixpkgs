{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "ghishadow";
  name = "lapce-swift";
  version = "0.1.4";
  hash = "sha256-UjHzSX3dMA13AlA73BKtbGnUKVy3h7zN2Um0cv/3fN0=";
  meta = {
    description = "Swift for Lapce: powered by sourcekit-lsp";
    homepage = "https://plugins.lapce.dev/plugins/ghishadow/lapce-swift";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

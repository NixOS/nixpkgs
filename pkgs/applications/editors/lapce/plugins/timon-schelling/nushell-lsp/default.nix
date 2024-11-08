{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "timon-schelling";
  name = "nushell-lsp";
  version = "0.1.0-rc2";
  hash = "sha256-/s982zGl85kxRoibwSpRiXxXD1Dgq6OUVvMXIUPP//4=";
  meta = {
    description = "Nushell language plugin using nushell's integrated lsp";
    homepage = "https://plugins.lapce.dev/plugins/timon-schelling/nushell-lsp";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

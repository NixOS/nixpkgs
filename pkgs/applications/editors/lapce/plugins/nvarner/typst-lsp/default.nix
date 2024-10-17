{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "nvarner";
  name = "typst-lsp";
  version = "0.13.0";
  hash = "sha256-ibo6fbq7+WvWVZGp1UB8bf+AeXTn70b5fCIkvTmfivQ=";
  meta = {
    description = "A language server for Typst";
    homepage = "https://plugins.lapce.dev/plugins/nvarner/typst-lsp";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

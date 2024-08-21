{ lapce-utils, lib }:

lapce-utils.pluginFromRegistry {
  author = "abreumatheus";
  name = "lapce-ruff-lsp";
  version = "0.1.1";
  hash = "sha256-ttYWC+GEQlFZR+Qu2rMLiKFDNsFeILRzDl6XQeiqqt0=";
  meta = {
    description = "Ruff LSP support for the Lapce editor.";
    homepage = "https://plugins.lapce.dev/plugins/abreumatheus/lapce-ruff-lsp";
    maintainers = with lib.maintainers; [ timon-schelling ];
    license = with lib.licenses; [ unfreeRedistributable ];
  };
}

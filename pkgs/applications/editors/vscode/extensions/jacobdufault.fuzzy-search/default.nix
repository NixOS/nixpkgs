{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "fuzzy-search";
    publisher = "jacobdufault";
    version = "0.0.3";
    hash = "sha256-oN1SzXypjpKOTUzPbLCTC+H3I/40LMVdjbW3T5gib0M=";
  };

  meta = {
    description = "Provides a fuzzy search using the quick pick window of the current text document.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=jacobdufault.fuzzy-search";
    homepage = "https://github.com/jacobdufault/vscode-fuzzy-search";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ AlexAntonik ];
  };
}

{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ndonfris";
    name = "fish-lsp";
    version = "0.1.11";
    hash = "sha256-I3ikOGK++GL51BGZBPWAIGvWBOAw5himdQvANlPog0s=";
  };

  meta = {
    description = "LSP implementation for the fish shell language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ndonfris.fish-lsp";
    homepage = "https://github.com/ndonfris/fish-lsp";
    license = lib.licenses.mit;
  };
}

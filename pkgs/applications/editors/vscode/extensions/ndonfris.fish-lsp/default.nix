{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ndonfris";
    name = "fish-lsp";
    version = "0.1.22";
    hash = "sha256-rbxjPThdqVSbE6aZ8pcN2awMNypPaN0KQ/BzgO2Aqog=";
  };

  meta = {
    description = "LSP implementation for the fish shell language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ndonfris.fish-lsp";
    homepage = "https://github.com/ndonfris/fish-lsp";
    license = lib.licenses.mit;
  };
}

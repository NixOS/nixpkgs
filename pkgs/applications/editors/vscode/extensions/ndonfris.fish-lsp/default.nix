{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ndonfris";
    name = "fish-lsp";
    version = "0.1.25";
    hash = "sha256-n2OspheZF/7Rw5WUV6NqwUqXQyaUuhM32c89FhHOJ3A=";
  };

  meta = {
    description = "LSP implementation for the fish shell language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ndonfris.fish-lsp";
    homepage = "https://github.com/ndonfris/fish-lsp";
    license = lib.licenses.mit;
  };
}

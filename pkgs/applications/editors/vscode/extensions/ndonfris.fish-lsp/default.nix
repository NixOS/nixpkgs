{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ndonfris";
    name = "fish-lsp";
    version = "0.1.10";
    hash = "sha256-aMuvBc2QVlRXpoBvWQaxC5SdwWzsauvVk1zMbK1p6oQ=";
  };

  meta = {
    description = "LSP implementation for the fish shell language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ndonfris.fish-lsp";
    homepage = "https://github.com/ndonfris/fish-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tuynia ];
  };
}

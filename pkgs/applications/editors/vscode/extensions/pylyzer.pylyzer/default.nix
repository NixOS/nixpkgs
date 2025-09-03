{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "pylyzer";
    publisher = "pylyzer";
    version = "0.1.11";
    hash = "sha256-RIJwzScCRTL9SJZ3B9PFBkocnGdZ7D8uYjcXPsTumho=";
  };

  meta = {
    description = "VS Code extension for Pylyzer, a fast static code analyzer & language server for Python";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=pylyzer.pylyzer";
    homepage = "https://github.com/mtshiba/pylyzer/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}

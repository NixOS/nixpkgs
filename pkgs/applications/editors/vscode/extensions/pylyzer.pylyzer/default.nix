{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "pylyzer";
    publisher = "pylyzer";
    version = "0.1.8";
    hash = "sha256-GoY4cobxL64bREtgl7q/iR66axSM3tBrle/b9h3ED8Q=";
  };

  meta = {
    description = "A VS Code extension for Pylyzer, a fast static code analyzer & language server for Python";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=pylyzer.pylyzer";
    homepage = "https://github.com/mtshiba/pylyzer/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}

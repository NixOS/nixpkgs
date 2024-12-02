{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "pylyzer";
    publisher = "pylyzer";
    version = "0.1.10";
    hash = "sha256-dDkX0U/XmHk5Jo+VdvxDkcA/1xu0Ae8kaDuDd/xjdUc=";
  };

  meta = {
    description = "A VS Code extension for Pylyzer, a fast static code analyzer & language server for Python";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=pylyzer.pylyzer";
    homepage = "https://github.com/mtshiba/pylyzer/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}

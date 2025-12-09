{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-pyright";
    name = "pyright";
    version = "1.1.407";
    hash = "sha256-x236ExuITXKqDoRgjDhnq9WnBbI1DvIIW/PXEYx2oVA=";
  };

  meta = {
    description = "VS Code static type checking for Python";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-pyright.pyright";
    homepage = "https://github.com/Microsoft/pyright#readme";
    changelog = "https://marketplace.visualstudio.com/items/ms-pyright.pyright/changelog";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ratsclub ];
  };
}

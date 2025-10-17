{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-pyright";
    name = "pyright";
    version = "1.1.406";
    hash = "sha256-Lz8x/op0RUluE7R6xssg2nVviT0O1tZXUopzKt0f99U=";
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

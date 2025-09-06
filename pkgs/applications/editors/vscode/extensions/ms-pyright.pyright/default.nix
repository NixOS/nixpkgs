{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-pyright";
    name = "pyright";
    version = "1.1.405";
    hash = "sha256-2UULr/D2ym5kBhbexl6U0r3dugZUuU+ks8FFfCi1A2k=";
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

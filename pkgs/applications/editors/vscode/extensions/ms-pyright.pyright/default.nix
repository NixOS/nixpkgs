{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-pyright";
    name = "pyright";
    version = "1.1.410";
    hash = "sha256-Ds1G+sRrfCxgNah9kj3w4LU86gF8dn3se7plNg3rvmE=";
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

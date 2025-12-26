{
  lib,
  vscode-utils,
  ...
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "basedpyright";
    publisher = "detachhead";
    version = "1.36.1";
    hash = "sha256-D3bKfUb/cm9zGfUCl0G/X2nxylZqSNv406BQ8c5GtgI=";
  };
  meta = {
    changelog = "https://github.com/detachhead/basedpyright/releases";
    description = "VS Code static type checking for Python (but based)";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=detachhead.basedpyright";
    homepage = "https://docs.basedpyright.com/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.hasnep ];
  };
}

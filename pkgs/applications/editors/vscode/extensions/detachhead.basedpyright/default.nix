{
  lib,
  vscode-utils,
  ...
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "basedpyright";
    publisher = "detachhead";
    version = "1.29.5";
    hash = "sha256-pvnGiJh+ZwsEZrS/JpaxQK7jMXO52hgHpL3nYR7t8kA=";
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

{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "cwtools-vscode";
    publisher = "tboby";
    version = "0.10.31";
    hash = "sha256-vECWkXwMWW6ZYQ+6lVpD1KAje1DY6z0APBS/0wIDMd4=";
  };
  meta = {
    description = "Paradox Language Features for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=tboby.cwtools-vscode";
    homepage = "https://github.com/cwtools/cwtools-vscode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}

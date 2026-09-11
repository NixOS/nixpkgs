{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-epics";
    publisher = "nsd";
    version = "1.1.0";
    hash = "sha256-ljd0UFFv0hA5jiM6xl4xOjM+z7u9I+H8O/j6m/U5U2c=";
  };
  meta = {
    description = "EPICS syntax highlighting and tools";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=nsd.vscode-epics";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.minijackson ];
  };
}

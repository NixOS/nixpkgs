{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "cwtools-vscode";
    publisher = "tboby";
    version = "0.10.25";
    hash = "sha256-TcnS4Cwn+V9hwScpLgUK5u8Jfm89EBv+koUOi1bB0DM=";
  };
  meta = {
    description = "Paradox Language Features for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=tboby.cwtools-vscode";
    homepage = "https://github.com/cwtools/cwtools-vscode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}

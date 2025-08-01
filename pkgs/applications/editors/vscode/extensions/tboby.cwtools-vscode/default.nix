{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "cwtools-vscode";
    publisher = "tboby";
    version = "0.10.26";
    hash = "sha256-1ZfmcF87LyRxCbQvVX21m1yFu+7QeDCofKXEHj5W8DA=";
  };
  meta = {
    description = "Paradox Language Features for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=tboby.cwtools-vscode";
    homepage = "https://github.com/cwtools/cwtools-vscode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}

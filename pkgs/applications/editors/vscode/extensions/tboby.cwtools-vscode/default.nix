{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "cwtools-vscode";
    publisher = "tboby";
    version = "0.10.30";
    hash = "sha256-C/2K1o6AOWumOwVjyNQZhqHe2T6LGW32dDJtLXIZguc=";
  };
  meta = {
    description = "Paradox Language Features for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=tboby.cwtools-vscode";
    homepage = "https://github.com/cwtools/cwtools-vscode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}

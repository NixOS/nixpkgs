{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ethersync";
    name = "ethersync";
    version = "0.6.0";
    hash = "sha256-KuidePUxQ+FhnIGTUf6i+WxBQfbQVlq68xbuOeEouIE=";
  };

  meta = {
    description = "Extension for real-time co-editing of local text files";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ethersync.ethersync";
    homepage = "https://github.com/ethersync/ethersync/tree/main/vscode-plugin";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.ethancedwards8 ];
    teams = [ lib.teams.ngi ];
  };
}

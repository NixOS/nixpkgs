{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "color-info";
    publisher = "bierner";
    version = "0.7.2";
    hash = "sha256-Bf0thdt4yxH7OsRhIXeqvaxD1tbHTrUc4QJcju7Hv90=";
  };
  meta = {
    description = "VSCode Extension that provides additional information about css colors";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=bierner.color-info";
    homepage = "https://github.com/mattbierner/vscode-color-info";
    changelog = "https://marketplace.visualstudio.com/items/bierner.color-info/changelog";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.timon ];
  };
}

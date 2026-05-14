{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "mongodb-vscode";
    publisher = "mongodb";
    version = "1.16.0";
    hash = "sha256-cnKYDrExL3yDJkEofWPglzMa50KDMgKQxsM5zK1RaBs=";
  };

  meta = {
    changelog = "https://github.com/mongodb-js/vscode/blob/main/CHANGELOG.md";
    description = "Extension for VS Code that makes it easy to work with your data in MongoDB";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=mongodb.mongodb-vscode";
    homepage = "https://github.com/mongodb-js/vscode";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

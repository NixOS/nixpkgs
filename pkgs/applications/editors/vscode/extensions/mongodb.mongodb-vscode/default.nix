{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "mongodb-vscode";
    publisher = "mongodb";
    version = "1.12.1";
    hash = "sha256-jbR6NGYgDYArCHqMHKPXuht7UViw0Ii3Uc8IqTGTe8k=";
  };

  meta = {
    changelog = "https://github.com/mongodb-js/vscode/blob/main/CHANGELOG.md";
    description = "An extension for VS Code that makes it easy to work with your data in MongoDB";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=mongodb.mongodb-vscode";
    homepage = "https://github.com/mongodb-js/vscode";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
  };
}

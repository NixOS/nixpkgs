{
  vscode-utils,
  lib,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "corn";
    publisher = "JakeStanger";
    version = "0.1.0";
    hash = "sha256-6c9lxwJDVUuT3VKAbIohd0mRHFbfmfDgKfYJ+XET5hQ=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/JakeStanger.corn/changelog";
    description = "Visual Studio Code extension for Cornlang";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=JakeStanger.corn";
    homepage = "https://github.com/corn-config/corn-vscode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}

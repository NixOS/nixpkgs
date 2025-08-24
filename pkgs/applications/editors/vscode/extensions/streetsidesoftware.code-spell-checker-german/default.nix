{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "code-spell-checker-german";
    publisher = "streetsidesoftware";
    version = "2.3.4";
    hash = "sha256-zc0cv4AOswvYcC4xJOq2JEPMQ5qTj9Dad5HhxtNETEs=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/streetsidesoftware.code-spell-checker-german/changelog";
    description = "German dictionary extension for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker-german";
    homepage = "https://streetsidesoftware.github.io/vscode-spell-checker-german";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.koschi13 ];
  };
}

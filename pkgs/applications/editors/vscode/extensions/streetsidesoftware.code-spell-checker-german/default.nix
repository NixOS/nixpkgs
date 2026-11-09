{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "code-spell-checker-german";
    publisher = "streetsidesoftware";
    version = "3.0.1";
    hash = "sha256-vc2DNiOm5zuwqVHyXnAH4j9+2V3X6qwqhBks9+pBOj8=";
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

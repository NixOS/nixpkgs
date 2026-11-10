{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "inline-html";
    publisher = "colton";
    version = "0.3.0";
    hash = "sha256-78aMz5KPVpnY/OhJoTRFecODhVqw0WIE/S3qV3ObnG4=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/colton.inline-html/changelog";
    description = "IntelliSense, Emmet and Syntax Highlighting for html/css inside ES6 Template Strings.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=colton.inline-html";
    homepage = "https://github.com/colton81/vscode-inline-html";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.frontear ];
  };
}

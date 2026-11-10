{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "lit-html";
    publisher = "bierner";
    version = "1.11.1";
    hash = "sha256-bN786jjTKkcrF0UUOG/J1/k1wqM7JfUO1pQomWLu8+I=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/bierner.lit-html/changelog";
    description = "Syntax highlighting and IntelliSense for html inside of JavaScript and TypeScript tagged template strings";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=bierner.lit-html";
    homepage = "https://github.com/mjbvz/vscode-lit-html";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.frontear ];
  };
}

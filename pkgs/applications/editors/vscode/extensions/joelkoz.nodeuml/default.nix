{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "nodeuml";
    publisher = "joelkoz";
    version = "2.1.1";
    hash = "sha256-sYVqldGk+eSqm/6gMAdEvWcN6GGn4G8xjkOUxs9fw0c=";
  };
  meta = {
    description = "Create UML class diagrams and generate code with NodeMDA.";
    homepage = "https://github.com/joelkoz/NodeUML#readme";
    changelog = "https://github.com/joelkoz/NodeUML/blob/master/CHANGELOG.md";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=joelkoz.nodeuml";
    license = lib.licenses.mit;
  };
}

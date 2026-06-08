{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "todo-tree";
    publisher = "Gruntfuggly";
    version = "0.0.226";
    hash = "sha256-Fj9cw+VJ2jkTGUclB1TLvURhzQsaryFQs/+f2RZOLHs=";
  };
  meta = {
    license = lib.licenses.mit;
  };
}

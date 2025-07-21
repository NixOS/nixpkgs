{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "language-hugo-vscode";
    publisher = "budparr";
    version = "1.3.1";
    hash = "sha256-9dp8/gLAb8OJnmsLVbOAKAYZ5whavPW2Ak+WhLqEbJk=";
  };

  meta = {
    description = "Adds syntax highlighting and snippets to Hugo files in VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=budparr.language-hugo-vscode";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ohheyrj ];
  };
}

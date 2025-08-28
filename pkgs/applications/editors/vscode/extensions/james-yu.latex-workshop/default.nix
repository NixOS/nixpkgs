{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "latex-workshop";
    publisher = "James-Yu";
    version = "10.10.2";
    hash = "sha256-Ls02bUSh5O5mDT2SEnaibvpHw535yelv5NaQ/NRM13k=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/James-Yu.latex-workshop/changelog";
    description = "LaTeX Workshop Extension";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop";
    homepage = "https://github.com/James-Yu/LaTeX-Workshop";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}

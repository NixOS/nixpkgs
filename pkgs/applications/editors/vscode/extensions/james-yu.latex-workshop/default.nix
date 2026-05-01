{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "latex-workshop";
    publisher = "James-Yu";
    version = "10.14.1";
    hash = "sha256-lsbiKzZTlkq/9K7ptLg0kHAd4i5OyNh2pLGGYUOJS9A=";
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

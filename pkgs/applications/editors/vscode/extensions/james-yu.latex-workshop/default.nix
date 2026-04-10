{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "latex-workshop";
    publisher = "James-Yu";
    version = "10.13.1";
    hash = "sha256-UyujvtuS0dok5xC4w1lGCwDxOSr58t1/YQ5Mpe6yNPM=";
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

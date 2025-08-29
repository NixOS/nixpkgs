{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "latex-workshop";
    publisher = "James-Yu";
    version = "10.10.1";
    hash = "sha256-TFaTpGfGk6RgFH/2gSGXCntBw6yWRg1lxHU+eEMBu3s=";
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

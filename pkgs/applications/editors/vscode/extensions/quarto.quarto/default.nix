{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "quarto";
    publisher = "quarto";
    version = "1.139.0";
    hash = "sha256-+BqGXFEaHGdNAg1yezCwz0mTZf4JCO4e2+tXnxFs8is=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/quarto.quarto/changelog";
    description = "Visual Studio Code extension for the Quarto scientific and technical publishing system";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=quarto.quarto";
    homepage = "https://github.com/quarto-dev/quarto/tree/main/apps/vscode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maj0e ];
  };
}

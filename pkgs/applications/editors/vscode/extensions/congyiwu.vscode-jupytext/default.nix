{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-jupytext";
    publisher = "congyiwu";
    version = "0.1.2";
    hash = "sha256-V9V4O1fdhY/ReKskixn113O0G1Mu1x9Z9SdChw9uVqU=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/congyiwu.vscode-jupytext/changelog";
    description = "Visual Studio Code extension for Jupytext support";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=congyiwu.vscode-jupytext";
    homepage = "https://github.com/congyiwu/vscode-jupytext";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.smissingham ];
  };
}

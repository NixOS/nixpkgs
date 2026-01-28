{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-augment";
    publisher = "augment";
    version = "0.754.3";
    hash = "sha256-y7vBumet1aiLFP45QRSXMYFqqqkGvBMRD0k8A/CPoC8=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/augment.vscode-augment/changelog";
    description = "AI-powered coding assistant for VSCode";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=augment.vscode-augment";
    homepage = "https://augmentcode.com/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = [ lib.maintainers.matteopacini ];
  };
}

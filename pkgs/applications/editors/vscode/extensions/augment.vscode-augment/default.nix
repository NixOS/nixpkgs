{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-augment";
    publisher = "augment";
    version = "0.654.2";
    hash = "sha256-Cfap8JB0krj1DpF6hoQamnbugdvjybWtO85vuxB7lcw=";
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

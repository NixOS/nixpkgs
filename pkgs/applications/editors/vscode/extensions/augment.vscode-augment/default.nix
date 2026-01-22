{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-augment";
    publisher = "augment";
    version = "0.754.2";
    hash = "sha256-PWcJr6hTCGeDLMG0h54x5D2n6zrK/bEqv7kygSZS/qo=";
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

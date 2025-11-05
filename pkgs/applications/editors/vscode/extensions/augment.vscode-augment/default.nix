{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-augment";
    publisher = "augment";
    version = "0.621.1";
    hash = "sha256-m0ys3MzgeT8PACqvhFpjnZeDSmMz+4IhhPgZCiUBmek=";
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

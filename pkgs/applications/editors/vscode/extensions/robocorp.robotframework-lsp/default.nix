{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "robotframework-lsp";
    publisher = "robocorp";
    version = "1.13.0";
    hash = "";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/myriad-dreamin.tinymist/changelog";
    description = "VSCode extension for providing an integration solution for Typst";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist";
    homepage = "https://github.com/myriad-dreamin/tinymist";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.drupol ];
  };
}

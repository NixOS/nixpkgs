{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "prototxt";
    publisher = "dmitry-korobchenko";
    version = "0.0.6";
    hash = "sha256-za8JuECOPp1PyyhgqDH+r7UGqcR59gVYqH8BaRRd9I8=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/dmitry-korobchenko.prototxt/changelog";
    description = "prototxt syntax highlighting, useful for Caffe users, for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=dmitry-korobchenko.prototxt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      frontear
    ];
  };
}

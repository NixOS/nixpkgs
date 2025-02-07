{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "dendron-markdown-preview-enhanced";
    publisher = "dendron";
    version = "0.10.57";
    hash = "sha256-uJmdsC+nKCkAJVH+szNepPcyfHD4ZQ83on195jjqZig=";
  };
  meta = {
    description = "A SUPER POWERFUL markdown extension for Visual Studio Code to bring you a wonderful markdown writing experience";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=dendron.dendron-markdown-preview-enhanced";
    homepage = "https://github.com/dendronhq/markdown-preview-enhanced";
    license = lib.licenses.ncsa;
    maintainers = [ lib.maintainers.ivyfanchiang ];
  };
}

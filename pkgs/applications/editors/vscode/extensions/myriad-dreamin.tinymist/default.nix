{
  lib,
  tinymist,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "tinymist";
    publisher = "myriad-dreamin";
    version = "0.14.16";
    hash = "sha256-R4tlQgtQaXIT6qiBg1RqQB0Usnsj0Ijs2Bhn2J1CQq4=";
  };

  buildInputs = [ tinymist ];

  executableConfig."tinymist.serverPath".package = tinymist;

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/myriad-dreamin.tinymist/changelog";
    description = "VSCode extension for providing an integration solution for Typst";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist";
    homepage = "https://github.com/myriad-dreamin/tinymist";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

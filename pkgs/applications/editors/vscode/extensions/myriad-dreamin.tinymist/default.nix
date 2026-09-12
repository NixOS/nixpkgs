{
  lib,
  tinymist,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "tinymist";
    publisher = "myriad-dreamin";
    inherit (tinymist) version;
    hash = "sha256-mTcTEvBsycCL2BW9EnmKJfyZN3aL6B/G8l8lnBTBojo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

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

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
    hash = "sha256-TrddbBxI7hXYlurQGMX1tcb1NmlRDjMT35ixgRMZT9U=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  buildInputs = [ tinymist ];

  defaultConfig."tinymist.serverPath" = tinymist;

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/myriad-dreamin.tinymist/changelog";
    description = "VSCode extension for providing an integration solution for Typst";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist";
    homepage = "https://github.com/myriad-dreamin/tinymist";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

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
    hash = "sha256-EgLt/bF0pdWyfSxwTGSv2Z0GxCZ2cJ9+n3UnTWdD1LE=";
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

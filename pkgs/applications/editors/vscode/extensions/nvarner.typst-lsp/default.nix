{
  jq,
  lib,
  moreutils,
  typst-lsp,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "typst-lsp";
    publisher = "nvarner";
    # Please update the corresponding binary (typst-lsp) when updating
    # this extension.
    version = "0.13.0";
    hash = "sha256-xiFUJymZOTEqlGvCHvLiI0pVg7NLgIXhZ7x8yx+a5mY=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  buildInputs = [ typst-lsp ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."typst-lsp.serverPath".default = "${lib.getExe typst-lsp}"' package.json | sponge package.json
  '';

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/nvarner.typst-lsp/changelog";
    description = "A VSCode extension for providing a language server for Typst";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=nvarner.typst-lsp";
    homepage = "https://github.com/nvarner/typst-lsp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.drupol ];
  };
}

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
    version = "0.12.1";
    hash = "sha256-JcfFaR1wU5XwapH8vnfVy7Cb7DfUWVeoLfBV3wEtCpE=";
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

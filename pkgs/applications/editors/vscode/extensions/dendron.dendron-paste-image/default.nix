{ lib, vscode-utils, ... }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "dendron-paste-image";
    publisher = "dendron";
    version = "1.1.1";
    hash = "sha256-SlW8MEWBgf8cJsdSzeegqPiAlEvlnrxuvrJJdhHwq2E=";
  };
  meta = {
    description = "Paste images directly from your clipboard to markdown/asciidoc(or other file)!";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=dendron.dendron-paste-image";
    homepage = "https://github.com/dendronhq/dendron-paste-image";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ivyfanchiang ];
  };
}

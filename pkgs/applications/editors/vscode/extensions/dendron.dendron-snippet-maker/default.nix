{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "dendron-snippet-maker";
    publisher = "dendron";
    version = "0.1.6";
    hash = "sha256-KOIbAt6EjqRGaqOlCV+HO9phR4tk2KV/+FMCefCKN+8=";
  };
  meta = {
    description = "Easily create markdown snippets. Used in Dendron but can also be used standalone";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=dendron.dendron-snippet-maker";
    homepage = "https://github.com/dendronhq/easy-snippet-maker";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ivyfanchiang ];
  };
}

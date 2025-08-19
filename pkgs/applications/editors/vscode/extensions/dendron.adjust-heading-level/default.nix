{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "adjust-heading-level";
    publisher = "dendron";
    version = "0.1.0";
    hash = "sha256-u50RJ7ETVFUC43mp94VJsR931b9REBaTyRhZE7muoLw=";
  };
  meta = {
    description = "VSCode extension to adjust the heading level of the selected text";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=dendron.adjust-heading-level";
    homepage = "https://github.com/kevinslin/adjust-heading-level";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivyfanchiang ];
  };
}

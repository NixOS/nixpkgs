{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "dendron";
    publisher = "dendron";
    version = "0.124.0";
    hash = "sha256-/hxgmmiMUfBtPt5BcuNvtXs3LzDmPwDuUOyDf2udHws=";
  };
  meta = {
    changelog = "https://github.com/dendronhq/dendron/blob/master/CHANGELOG.md";
    description = "Personal knowledge management (PKM) tool that grows as you do";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=dendron.dendron";
    homepage = "https://www.dendron.so/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivyfanchiang ];
  };
}

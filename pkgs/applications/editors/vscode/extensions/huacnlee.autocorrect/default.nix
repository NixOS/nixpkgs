{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "autocorrect";
    publisher = "huacnlee";
    version = "2.6.4";
    hash = "sha256-1cN36FnslttmH66J4Xah1KohM2nEQckNUXHZD+ps2uY=";
  };

  meta = {
    description = "AutoCorrect is a linter and formatter to help you to improve copywriting, correct spaces, words, and punctuations between CJK (Chinese, Japanese, Korean)";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=huacnlee.autocorrect";
    homepage = "https://github.com/huacnlee/autocorrect";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}

{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "nimlang";
    publisher = "nimlang";
    version = "1.8.0";
    hash = "sha256-5GwCKDG8DJnen0zDJYeFuqhyitPyORRPsB+DvbzAivw=";
  };
  meta = {
    description = "Nim language support for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=nimlang.nimlang";
    homepage = "https://github.com/nim-lang/vscode-nim";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}

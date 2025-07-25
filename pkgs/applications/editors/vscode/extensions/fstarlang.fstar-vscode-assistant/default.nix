{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "fstar-vscode-assistant";
    publisher = "FStarLang";
    version = "0.18.1";
    hash = "sha256-uiw3EJbYoDG5r93NIxloiF7Co3gxcZT9+hlLZFnxkBE=";
  };
  meta = {
    description = "An interactive editing mode VS Code extension for F*";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=FStarLang.fstar-vscode-assistant";
    homepage = "https://github.com/FStarLang/fstar-vscode-assistant";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.parrot7483 ];
  };
}

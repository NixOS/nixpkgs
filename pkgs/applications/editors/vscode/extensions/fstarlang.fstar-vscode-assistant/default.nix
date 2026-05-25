{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "fstar-vscode-assistant";
    publisher = "FStarLang";
    version = "0.24.0";
    hash = "sha256-2XFisNp/TvkBNytzs56kdMnaZTX6f1qWp1k59uLwcuE=";
  };
  meta = {
    description = "Interactive editing mode VS Code extension for F*";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=FStarLang.fstar-vscode-assistant";
    homepage = "https://github.com/FStarLang/fstar-vscode-assistant";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.parrot7483 ];
  };
}

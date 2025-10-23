{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "fstar-vscode-assistant";
    publisher = "FStarLang";
    version = "0.21.0";
    hash = "sha256-p1Gh7HKcEXGiObzFt0P/hGS0e5g8ekktmAqSWi6sJwA=";
  };
  meta = {
    description = "Interactive editing mode VS Code extension for F*";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=FStarLang.fstar-vscode-assistant";
    homepage = "https://github.com/FStarLang/fstar-vscode-assistant";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.parrot7483 ];
  };
}

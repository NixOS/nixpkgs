{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "fstar-vscode-assistant";
    publisher = "FStarLang";
    version = "0.25.4";
    hash = "sha256-9gPM/T3Kbwt40V2ZuzN/OkQVNATsp4AYK9HuOu/Ui+0=";
  };
  meta = {
    description = "Interactive editing mode VS Code extension for F*";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=FStarLang.fstar-vscode-assistant";
    homepage = "https://github.com/FStarLang/fstar-vscode-assistant";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.parrot7483 ];
  };
}

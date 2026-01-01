{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "fstar-vscode-assistant";
    publisher = "FStarLang";
<<<<<<< HEAD
    version = "0.23.1";
    hash = "sha256-AwYR74qyoEsn+LixmFwqzwA6yM0MBtWU4SKcxslNSOk=";
=======
    version = "0.22.0";
    hash = "sha256-jDHVN34f/HlE74+uXt4tx8cDjh9pG4nKZG5CaHKT9oE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  meta = {
    description = "Interactive editing mode VS Code extension for F*";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=FStarLang.fstar-vscode-assistant";
    homepage = "https://github.com/FStarLang/fstar-vscode-assistant";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.parrot7483 ];
  };
}

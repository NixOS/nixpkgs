{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "winteriscoming";
    publisher = "johnpapa";
    version = "1.5.0";
    hash = "sha256-Q7FqtzCatqwpDqh9h3iMJmPMeebaBkIX8lDcF3Sgqa8=";
  };
  meta = {
    description = "Preferred dark/light themes by John Papa";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=johnpapa.winteriscoming";
    homepage = "https://github.com/johnpapa/vscode-winteriscoming";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}

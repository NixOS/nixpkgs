{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "winteriscoming";
    publisher = "johnpapa";
    version = "1.4.4";
    hash = "sha256-47zCB7VDj+gYXUeblbNsWnGMJt4U4UMyqU1NYTmz2Jc=";
  };
  meta = {
    description = "Preferred dark/light themes by John Papa";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=johnpapa.winteriscoming";
    homepage = "https://github.com/johnpapa/vscode-winteriscoming";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}

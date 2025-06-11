{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "gremlins";
    publisher = "nhoizey";
    version = "0.26.0";
    hash = "sha256-ML04SccSOrj5qY0HHJ5jiNbWkPElU1+zZNSX2i1K2uk=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/nhoizey.gremlins/changelog";
    description = "Reveals some characters that can be harmful because they are invisible or looking like legitimate ones";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=nhoizey.gremlins";
    homepage = "https://github.com/nhoizey/vscode-gremlins";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.theobori ];
  };
}

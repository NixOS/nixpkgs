{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "jasew";
    name = "anki";
    version = "1.3.5";
    hash = "sha256-QPuafIelmhdno/E2zr6NQChv0qjfjMFwx7v0Xat/gDc=";
  };

  meta = {
    description = "Extension for interacting and sending cards to Anki";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=jasew.anki";
    homepage = "https://github.com/jasonwilliams/anki";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}

{
  lib,
  millet,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "Millet";
    publisher = "azdavis";
    version = "0.15.1";
    hash = "sha256-5V5GG7M52ohpS9Zg2TTamEjbWyXH9kllZyy7Oezy4Iw=";
  };
  executableConfig."millet.server.path".package = millet;
  meta = {
    description = "Standard ML support for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=azdavis.millet";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.smasher164 ];
  };
}

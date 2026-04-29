{
  lib,
  vscode-utils,
  akkuPackages,
  chez,
  akku,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ufo5260987423";
    name = "magic-scheme";
    version = "0.0.6";
    hash = "sha256-ibEdsw/ulr+cagB90uALDbSsQV18dPULANCdnjPvhuI=";
  };

  executableConfig = {
    "magicScheme.scheme-langserver.serverPath".package = akkuPackages.scheme-langserver;
    "magicScheme.scheme.path".package = chez;
    "magicScheme.akku.path".package = akku;
  };

  meta = {
    description = "Adds support for Scheme(r6rs standard)";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ufo5260987423.magic-scheme";
    homepage = "https://github.com/ufo5260987423/magic-scheme";
    license = lib.licenses.mit;
  };
}

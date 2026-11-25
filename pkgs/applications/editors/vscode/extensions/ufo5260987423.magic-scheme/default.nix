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
    version = "0.0.17";
    hash = "sha256-pG1TfSXdpGXrS3SG28k/p3p2/kkUezhzAqRePp6k4wA=";
  };

  defaultConfig = {
    "magicScheme.scheme-langserver.serverPath" = akkuPackages.scheme-langserver;
    "magicScheme.scheme.path" = chez;
    "magicScheme.akku.path" = akku;
  };

  meta = {
    description = "Adds support for Scheme(r6rs standard)";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ufo5260987423.magic-scheme";
    homepage = "https://github.com/ufo5260987423/magic-scheme";
    license = lib.licenses.mit;
  };
}

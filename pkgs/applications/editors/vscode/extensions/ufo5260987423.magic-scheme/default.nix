{
  lib,
  vscode-utils,
  jq,
  akkuPackages,
  chez,
  akku,
  moreutils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ufo5260987423";
    name = "magic-scheme";
    version = "0.0.6";
    hash = "sha256-ibEdsw/ulr+cagB90uALDbSsQV18dPULANCdnjPvhuI=";
  };

  postInstall = ''
    cd "$out/$installPrefix"
    ${lib.getExe jq} '.contributes.configuration.properties."magicScheme.scheme-langserver.serverPath".default = "${lib.getExe' akkuPackages.scheme-langserver "scheme-langserver"}" | .contributes.configuration.properties."magicScheme.scheme.path".default = "${lib.getExe' chez "scheme"}" | .contributes.configuration.properties."magicScheme.akku.path".default = "${lib.getExe akku}"' package.json | ${lib.getExe' moreutils "sponge"} package.json
  '';

  meta = {
    description = "Adds support for Scheme(r6rs standard)";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ufo5260987423.magic-scheme";
    homepage = "https://github.com/ufo5260987423/magic-scheme";
    license = lib.licenses.mit;
  };
}

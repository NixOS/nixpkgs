{
  lib,
  jq,
  moreutils,
  millet,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "Millet";
    publisher = "azdavis";
    version = "0.14.7";
    hash = "sha256-+PrGTeov5lTP1SgB6E0E40QHXfX+/vhm2DzW6DJB1/A=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."millet.server.path".default = "${millet}/bin/millet-ls"' package.json | sponge package.json
  '';
  meta = {
    description = "Standard ML support for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=azdavis.millet";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.smasher164 ];
  };
}

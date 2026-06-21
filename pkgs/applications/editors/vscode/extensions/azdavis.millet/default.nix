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
    version = "0.15.2";
    hash = "sha256-mtI4IW+xBIuo11ctTIv5/6LOXVStD3YqSYkIQYJWqmo=";
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

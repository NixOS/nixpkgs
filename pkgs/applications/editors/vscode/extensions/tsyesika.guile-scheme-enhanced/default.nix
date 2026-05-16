{
  lib,
  vscode-utils,
  jq,
  guile,
  moreutils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "tsyesika";
    name = "guile-scheme-enhanced";
    version = "0.0.2";
    hash = "sha256-uoHYfbLeANHnMB7OgDQPfIIlNN7LgERS9zQfa+QIk0M=";
  };

  postInstall = ''
    cd "$out/$installPrefix"
    ${lib.getExe jq} '.contributes.configuration.properties."guileScheme.guileREPLCommand".default = "${lib.getExe' guile "guile"}"' package.json | ${lib.getExe' moreutils "sponge"} package.json
  '';

  meta = {
    description = "Better experience for working with scheme";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=tsyesika.guile-scheme-enhanced";
    homepage = "https://codeberg.org/tsyesika/vscode-guile-scheme-enhanced";
    license = lib.licenses.asl20;
  };
}

{
  lib,
  vscode-utils,
  guile,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "tsyesika";
    name = "guile-scheme-enhanced";
    version = "0.0.2";
    hash = "sha256-uoHYfbLeANHnMB7OgDQPfIIlNN7LgERS9zQfa+QIk0M=";
  };

  executableConfig."guileScheme.guileREPLCommand".package = guile;

  meta = {
    description = "Better experience for working with scheme";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=tsyesika.guile-scheme-enhanced";
    homepage = "https://codeberg.org/tsyesika/vscode-guile-scheme-enhanced";
    license = lib.licenses.asl20;
  };
}

{
  clojure-lsp,
  jq,
  lib,
  moreutils,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "calva";
    publisher = "betterthantomorrow";
    version = "2.0.496";
    hash = "sha256-vf6JwsMMAcAZMXTRrczgEpvmmN34eSgsO8QXNL4+DHM=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration[0].properties."calva.clojureLspPath".default = "${clojure-lsp}/bin/clojure-lsp"' package.json | sponge package.json
  '';
  meta = {
    license = lib.licenses.mit;
  };
}

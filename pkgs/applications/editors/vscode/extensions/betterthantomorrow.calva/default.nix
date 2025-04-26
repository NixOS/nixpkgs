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
    version = "2.0.502";
    hash = "sha256-TEU1+8IUz0GqWoB2DSE+TzyHFLL0nMSMiZyzWD6IoEA=";
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

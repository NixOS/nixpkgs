{
  lib,
  clojure-lsp,
  jq,
  moreutils,
  vscode-utils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "calva";
    publisher = "betterthantomorrow";
    version = "2.0.538";
    hash = "sha256-lJ9AnTNN9TkPDh9u2KV1BLn/fgZOWSOXNOTAdV+r6s4=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration[0].properties."calva.clojureLspPath".default = "${clojure-lsp}/bin/clojure-lsp"' package.json | sponge package.json
  '';

  passthru.updateScript = vscode-extension-update-script {
    extraArgs = [
      "--override-filename"
      "pkgs/applications/editors/vscode/extensions/betterthantomorrow.calva/default.nix"
    ];
  };

  meta.license = lib.licenses.mit;
}

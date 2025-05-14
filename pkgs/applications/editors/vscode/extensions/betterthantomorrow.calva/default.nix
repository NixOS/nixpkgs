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
    version = "2.0.509";
    hash = "sha256-4OTgwzLG21W3BR3EhepzhCwTnBmhDsoQ5GWN00kZqCY=";
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

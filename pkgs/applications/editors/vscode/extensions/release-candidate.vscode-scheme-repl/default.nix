{
  lib,
  vscode-utils,
  jq,
  chez,
  moreutils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "release-candidate";
    name = "vscode-scheme-repl";
    version = "0.7.4";
    hash = "sha256-Pfy0aJXq8I53o5mG4dfzyqsyLQX0bs+phBgN46yU/Yw=";
  };

  postInstall = ''
    cd "$out/$installPrefix"
    ${lib.getExe jq} '.contributes.configuration.properties."chezScheme.schemePath" = "${lib.getExe' chez "scheme"}"' package.json | ${lib.getExe' moreutils "sponge"} package.json
  '';

  meta = {
    description = "Uses REPL for autocompletions and to evaluate expressions";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=release-candidate.vscode-scheme-repl";
    homepage = "https://github.com/Release-Candidate/vscode-scheme-repl";
    license = lib.licenses.mit;
  };
}

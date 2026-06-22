{
  lib,
  vscode-utils,
  chez,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "release-candidate";
    name = "vscode-scheme-repl";
    version = "0.7.4";
    hash = "sha256-Pfy0aJXq8I53o5mG4dfzyqsyLQX0bs+phBgN46yU/Yw=";
  };

  executableConfig."chezScheme.schemePath".package = chez;

  meta = {
    description = "Uses REPL for autocompletions and to evaluate expressions";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=release-candidate.vscode-scheme-repl";
    homepage = "https://github.com/Release-Candidate/vscode-scheme-repl";
    license = lib.licenses.mit;
  };
}

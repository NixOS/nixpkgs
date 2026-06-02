{
  lib,
  symlinkJoin,
  runCommand,
  makeBinaryWrapper,
  helix-unwrapped,
  removeReferencesTo,
  pkgs,
  tree-sitter,
  lockedGrammars ? lib.importJSON ./grammars.json,
  grammarsOverlay ? (
    final: prev: {
      tree-sitter-beancount = prev.tree-sitter-beancount.override {
        excludeBrokenTreeSitterJson = false;
      };
      tree-sitter-git-rebase = prev.tree-sitter-git-rebase.overrideAttrs {
        dontPatch = true;
      };
      tree-sitter-glimmer = prev.tree-sitter-glimmer.override {
        excludeBrokenTreeSitterJson = false;
      };
      tree-sitter-janet-simple = prev.tree-sitter-janet-simple.override {
        excludeBrokenTreeSitterJson = false;
      };
      tree-sitter-qmljs = prev.tree-sitter-qmljs.overrideAttrs {
        dontCheckForBrokenSymlinks = true;
      };
      tree-sitter-sql = prev.tree-sitter-sql.override {
        generate = false;
      };
    }
  ),
}:
let
  lockedVersionsOverlay =
    final: prev:
    lib.mapAttrs (
      drvName: grammar:
      let
        lockedGrammar = lockedGrammars.${lib.removePrefix "tree-sitter-" drvName};
      in
      (prev.${drvName}.override {
        location = lockedGrammar.subpath;
      }).overrideAttrs
        {
          version = lib.sources.shortRev lockedGrammar.nurl.args.rev;
          src = (pkgs.${lockedGrammar.nurl.fetcher} lockedGrammar.nurl.args);
        }
    ) prev;

  tree-sitter-grammars =
    lib.filterAttrs (drvName: _: lib.hasAttr (lib.removePrefix "tree-sitter-" drvName) lockedGrammars)
      (
        tree-sitter.grammarsScope.overrideScope (
          lib.composeExtensions lockedVersionsOverlay grammarsOverlay
        )
      );

  # Dynamic libraries for the grammars always use the `.so` extension, also on Darwin (should use `.dylib`)
  # See here: https://github.com/helix-editor/helix/pull/14982
  # Switch to `stdenv.hostPlatform.extensions.sharedLibrary` once the fix above reaches the next release

  grammarsFarm = runCommand "helix-grammars" { } (
    lib.concatMapAttrsStringSep "\n" (_: grammar: ''
      install -D ${grammar}/parser $out/${grammar.language}.so
      ${lib.getExe removeReferencesTo} -t ${grammar} $out/${grammar.language}.so
    '') (lib.filterAttrs (_: lib.isDerivation) tree-sitter-grammars)
  );

  lockedGrammarsCount = lib.length (lib.attrNames lockedGrammars);

  runtimeDir = runCommand "helix-runtime" { } ''
    mkdir -p $out
    ln -s ${grammarsFarm} $out/grammars
    cp -r --no-preserve=mode ${helix-unwrapped.src}/runtime/queries $out
    count=$(ls -1 "$out/grammars/" | wc -l)
    if [ "$count" -ne ${toString lockedGrammarsCount} ]; then
      echo "Expected ${toString lockedGrammarsCount} grammars, found $count"
      exit 1
    fi
  '';
in

symlinkJoin {
  pname = "helix";
  inherit (helix-unwrapped) version;

  paths = [ helix-unwrapped ];
  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    wrapProgram $out/bin/hx --set HELIX_RUNTIME "${runtimeDir}"
  '';

  passthru = {
    updateScript = ./update.sh;
    runtime = runtimeDir;
    inherit tree-sitter-grammars;
  };

  meta = {
    inherit (helix-unwrapped.meta)
      description
      homepage
      changelog
      license
      mainProgram
      maintainers
      ;
  };
}

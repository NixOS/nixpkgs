{
  stdenv,
  lib,
  runCommand,
  includeGrammarIf ? _: true,
  fetchFromGitHub,
  fetchgit,
  ...
}: let
  # similiar to https://github.com/helix-editor/helix/blob/23.05/grammars.nix
  grammars = builtins.fromJSON (builtins.readFile ./language-grammars.json);
  isGitGrammar = grammar:
    builtins.hasAttr "source" grammar
    && builtins.hasAttr "git" grammar.source
    && builtins.hasAttr "rev" grammar.source;
  isGitHubGrammar = grammar: lib.hasPrefix "https://github.com" grammar.source.git;
  toGitHubFetcher = url: let
    match = builtins.match "https://github\.com/([^/]*)/([^/]*)/?" url;
  in {
    owner = builtins.elemAt match 0;
    repo = builtins.elemAt match 1;
  };
  gitGrammars = builtins.filter isGitGrammar grammars;
  buildGrammar = grammar: let
    gh = toGitHubFetcher grammar.source.git;
    sourceGit = fetchgit {
      url = grammar.source.git;
      inherit (grammar.source) rev sha256;
    };
    sourceGitHub = fetchFromGitHub {
      owner = gh.owner;
      repo = gh.repo;
      inherit (grammar.source) rev sha256;
    };
    source =
      if isGitHubGrammar grammar
      then sourceGitHub
      else sourceGit;
  in
    stdenv.mkDerivation rec {
      # similar to tree-sitter grammar generation
      pname = "helix-tree-sitter-grammar-${grammar.name}";
      version = grammar.source.rev;

      src =
        if builtins.hasAttr "subpath" grammar.source
        then "${source}/${grammar.source.subpath}"
        else source;

      dontConfigure = true;

      FLAGS = [
        "-I${src}/src"
        "-g"
        "-O3"
        "-fPIC"
        "-fno-exceptions"
        "-Wl,-z,relro,-z,now"
      ];

      NAME = grammar.name;

      buildPhase = ''
        runHook preBuild

        if [[ -e "src/scanner.cc" ]]; then
          $CXX -c "src/scanner.cc" -o scanner.o $FLAGS
        elif [[ -e "src/scanner.c" ]]; then
          $CC -c "src/scanner.c" -o scanner.o $FLAGS
        fi

        $CC -c "src/parser.c" -o parser.o $FLAGS
        $CXX -shared -o $NAME.so *.o

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir $out
        mv $NAME.so $out/
        runHook postInstall
      '';

      # Strip failed on darwin: strip: error: symbols referenced by indirect symbol table entries that can't be stripped
      fixupPhase = lib.optionalString stdenv.isLinux ''
        runHook preFixup
        $STRIP $out/$NAME.so
        runHook postFixup
      '';
    };
  grammarsToBuild = builtins.filter includeGrammarIf gitGrammars;
  builtGrammars =
    builtins.map (grammar: {
      inherit (grammar) name;
      artifact = buildGrammar grammar;
    })
    grammarsToBuild;
  grammarLinks =
    builtins.map (grammar: "ln -s ${grammar.artifact}/${grammar.name}.so $out/${grammar.name}.so")
    builtGrammars;
in
  runCommand "helix-tree-sitter-grammars" {} ''
    mkdir -p $out
    ${builtins.concatStringsSep "\n" grammarLinks}
  ''

{
  lib,
  stdenv,
  pkgs,
}:
let
  grammarSources = lib.mapAttrs (
    name: source:
    (pkgs.${source.nurl.fetcher} source.nurl.args)
    // {
      passthru = { inherit (source) subpath; };
    }
  ) (lib.importJSON ./grammars.json);

  mkGrammar =
    name: source:
    stdenv.mkDerivation {
      pname = "helix-tree-sitter-${name}";
      version = lib.sources.shortRev source.rev;

      src = source;
      sourceRoot =
        if isNull source.passthru.subpath then "source" else "source/${source.passthru.subpath}";

      dontConfigure = true;

      FLAGS = [
        "-Isrc"
        "-g"
        "-O3"
        "-fPIC"
        "-fno-exceptions"
        "-Wl,-z,relro,-z,now"
      ];

      env.NAME = name;

      buildPhase = ''
        runHook preBuild

        if [[ -e src/scanner.cc ]]; then
          $CXX -c src/scanner.cc -o scanner.o $FLAGS
        elif [[ -e src/scanner.c ]]; then
          $CC -c src/scanner.c -o scanner.o $FLAGS
        fi

        $CC -c src/parser.c -o parser.o $FLAGS
        $CXX -shared -o $NAME.so *.o

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir $out
        mv $NAME.so $out/

        runHook postInstall
      '';

      fixupPhase = ''
        runHook preFixup

        $STRIP $out/$NAME.so

        runHook postFixup
      '';

      broken = stdenv.hostPlatform.isStatic;
    };
in
lib.mapAttrs mkGrammar grammarSources

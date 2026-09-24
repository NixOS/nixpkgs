{
  lib,
  buildEnv,
  hunspell,
  hunspellDicts,
  makeBinaryWrapper,
}:

lib.makeOverridable (
  { ... }@dicts:
  f:
  buildEnv {
    inherit (lib.appendToName "with-dicts" hunspell) name;

    paths = f dicts;

    pathsToLink = [ "/share/hunspell" ];

    nativeBuildInputs = [ makeBinaryWrapper ];

    postBuild = ''
      makeWrapper ${lib.getExe hunspell} $out/bin/hunspell \
        --prefix DICPATH : $out/share/hunspell
    '';

    meta = {
      inherit (hunspell.meta)
        description
        longDescription
        homepage
        changelog
        license
        maintainers
        mainProgram
        platforms
        ;
    };
  }
) hunspellDicts

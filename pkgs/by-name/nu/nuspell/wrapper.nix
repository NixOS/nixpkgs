{
  lib,
  buildEnv,
  nuspell,
  hunspellDicts,
  makeBinaryWrapper,
}:

lib.makeOverridable (
  dicts: f:
  buildEnv {
    inherit (lib.appendToName "with-dicts" nuspell) name version;

    paths = f dicts;

    pathsToLink = [ "/share/hunspell" ];

    nativeBuildInputs = [ makeBinaryWrapper ];

    postBuild = ''
      makeWrapper ${lib.getExe nuspell} $out/bin/nuspell \
        --prefix DICPATH : $out/share/hunspell
    '';

    meta = {
      inherit (nuspell.meta)
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

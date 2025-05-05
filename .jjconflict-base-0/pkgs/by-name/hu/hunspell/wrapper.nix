{
  stdenv,
  lib,
  hunspell,
  makeBinaryWrapper,
  dicts ? [ ],
}:
let
  searchPath = lib.makeSearchPath "share/hunspell" dicts;
in
stdenv.mkDerivation {
  inherit (lib.appendToName "with-dicts" hunspell) name;

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildCommand = ''
    makeWrapper ${lib.getExe hunspell} $out/bin/hunspell \
      --prefix DICPATH : ${lib.escapeShellArg searchPath}
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

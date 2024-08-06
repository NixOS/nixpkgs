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
    wrapProgram $out/bin/hunspell --prefix DICPATH : ${lib.escapeShellArg searchPath}
  '';
  meta = removeAttrs hunspell.meta [ "outputsToInstall" ];
}

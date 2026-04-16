{
  lib,
  stdenv,
  makeWrapper,
  lessc,
  plugins ? [ ],
}:

stdenv.mkDerivation {
  pname = "lessc-with-plugins";
  nativeBuildInputs = [ makeWrapper ];
  buildPhase = ''
    mkdir -p $out/bin

    makeWrapper "${lessc.exe}" "$out/bin/lessc" \
      --prefix NODE_PATH : "${lib.makeSearchPath "/lib/node_modules" plugins}"
  '';

  doUnpack = false;

  inherit (lessc)
    version
    src
    passthru
    meta
    ;
}

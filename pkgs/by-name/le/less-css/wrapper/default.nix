{
  lib,
  stdenv,
  makeWrapper,
  less-css,
  plugins ? [ ],
}:

let
  makeNodePath = paths: lib.makeSearchPath "/lib/node_modules" paths;
in
stdenv.mkDerivation {
  pname = "less-css-with-plugins";
  nativeBuildInputs = [ makeWrapper ];
  buildPhase = ''
    mkdir -p $out/bin

    exe_name="$(basename "${lib.getExe less-css}")"
    makeWrapper "${lib.getExe less-css}" "$out/bin/$exe_name" \
      --prefix NODE_PATH : "${makeNodePath plugins}"
  '';

  doUnpack = false;

  inherit (less-css)
    version
    src
    passthru
    meta
    ;
}

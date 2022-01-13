{ lib
, stdenvNoCC
, fetchurl
, undmg
, pname
, version
, hash
, metaCommon ? { }
}:

let
  pname = "losslesscut";
  src = fetchurl {
    url = "https://github.com/mifi/lossless-cut/releases/download/v${version}/LosslessCut-mac-x64.dmg";
    inherit hash;
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "LosslessCut.app";

  installPhase = ''
    mkdir -p "$out/Applications/LosslessCut.app"
    cp -R . "$out/Applications/LosslessCut.app"
    mkdir -p "$out/bin"
    ln -s "$out/Applications/LosslessCut.app/Contents/MacOS/LosslessCut" "$out/bin/losslesscut"
  '';

  meta = metaCommon // (with lib; {
    platforms = platforms.darwin;
    mainProgram = "losslesscut";
  });
}

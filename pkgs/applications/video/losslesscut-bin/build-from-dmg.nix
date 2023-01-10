{ lib
, stdenvNoCC
, fetchurl
, undmg
, pname
, version
, hash
, isAarch64
, metaCommon ? { }
}:

let
  pname = "losslesscut";
  src = fetchurl {
    url = "https://github.com/mifi/lossless-cut/releases/download/v${version}/LosslessCut-mac-${if isAarch64 then "arm64" else "x64"}.dmg";
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
    platforms = singleton (if isAarch64 then "aarch64-darwin" else "x86_64-darwin");
    mainProgram = "losslesscut";
  });
}

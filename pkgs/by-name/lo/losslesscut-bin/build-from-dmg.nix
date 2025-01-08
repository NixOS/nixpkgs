{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  pname ? "losslesscut",
  version,
  hash,
  isAarch64,
  metaCommon ? { },
}:

let
  src = fetchurl {
    url = "https://github.com/mifi/lossless-cut/releases/download/v${version}/LosslessCut-mac-${
      if isAarch64 then "arm64" else "x64"
    }.dmg";
    inherit hash;
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ _7zz ];

  sourceRoot = "LosslessCut.app";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cd ..
    mv "$sourceRoot" "$out/Applications"
    mkdir -p "$out/bin"
    ln -s "$out/Applications/$(basename "$sourceRoot")/Contents/MacOS/LosslessCut" "$out/bin/losslesscut"
    runHook postInstall
  '';

  meta =
    metaCommon
    // {
      platforms = if isAarch64 then [ "aarch64-darwin" ] else lib.platforms.darwin;
      mainProgram = "losslesscut";
    };
}

{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  pname,
  version,
  hash,
  isAarch64,
  metaCommon ? { },
}:

stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/mifi/lossless-cut/releases/download/v${version}/LosslessCut-mac-${
      if isAarch64 then "arm64" else "x64"
    }.dmg";
    inherit hash;
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -r LosslessCut.app "$out/Applications"
    mkdir -p "$out/bin"
    ln -s "$out/Applications/LosslessCut.app/Contents/MacOS/LosslessCut" "$out/bin/losslesscut"
    runHook postInstall
  '';

  meta = metaCommon // {
    platforms = if isAarch64 then [ "aarch64-darwin" ] else lib.platforms.darwin;
    mainProgram = "losslesscut";
  };
}

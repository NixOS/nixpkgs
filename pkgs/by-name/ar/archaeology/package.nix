{
  lib,
  fetchurl,
  stdenv,
  undmg,
}:

let
  snapshot = "20250105232819";
in
stdenv.mkDerivation {
  pname = "archaeology";
  version = "1.2";

  src = fetchurl {
    # Use externally archived download URL because
    # upstream does not provide stable URLs for versioned releases
    url = "https://web.archive.org/web/${snapshot}/https://www.mothersruin.com/software/downloads/Archaeology.dmg";
    hash = "sha256-DKpScOyaz4P/iwqI2A1DJA+bVoCt43N4f1H6QVoc5eI=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Archaeology.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Archaeology.app $out/bin
    cp -R . $out/Applications/Archaeology.app
    ln -s ../Applications/Archaeology.app/Contents/MacOS/trowel $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Tool for digging into binary files on macOS";
    homepage = "https://www.mothersruin.com/software/Archaeology/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "trowel";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

{
  lib,
  fetchurl,
  stdenv,
  undmg,
}:

let
  snapshot = "20250105225747";
in
stdenv.mkDerivation {
  pname = "apparency";
  version = "2.2";

  src = fetchurl {
    # Use externally archived download URL because
    # upstream does not provide stable URLs for versioned releases
    url = "https://web.archive.org/web/${snapshot}/https://www.mothersruin.com/software/downloads/Apparency.dmg";
    hash = "sha256-nktNbyJOXDydQPwb43Uq3nQv65XcwrqZTKu5OCcLyfU=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Apparency.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Apparency.app $out/bin
    cp -R . $out/Applications/Apparency.app
    ln -s ../Applications/Apparency.app/Contents/MacOS/appy $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Toolkit for analysing macOS applications";
    homepage = "https://www.mothersruin.com/software/Apparency/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "appy";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

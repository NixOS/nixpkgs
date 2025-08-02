{
  lib,
  fetchurl,
  stdenv,
  undmg,
}:

let
  snapshot = "20250105231831";
in
stdenv.mkDerivation {
  pname = "suspicious-package";
  version = "4.5";

  src = fetchurl {
    # Use externally archived download URL because
    # upstream does not provide stable URLs for versioned releases
    url = "https://web.archive.org/web/${snapshot}/https://www.mothersruin.com/software/downloads/SuspiciousPackage.dmg";
    hash = "sha256-//iL7BRdox+KA1CJnGttUQiUfskuBeMGrf1YUNt/m90=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Suspicious Package.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Suspicious Package.app" $out/bin
    cp -R . "$out/Applications/Suspicious Package.app"
    ln -s "../Applications/Suspicious Package.app/Contents/SharedSupport/spkg" $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Toolkit for analysing macOS packages";
    homepage = "https://www.mothersruin.com/software/SuspiciousPackage/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "spkg";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

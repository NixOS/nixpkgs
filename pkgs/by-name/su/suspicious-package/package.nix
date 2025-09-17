{
  lib,
  fetchurl,
  stdenv,
  undmg,
  versionCheckHook,
}:

let
  snapshot = "20250820185748";
in
stdenv.mkDerivation {
  pname = "suspicious-package";
  version = "4.6";

  src = fetchurl {
    # Use externally archived download URL because
    # upstream does not provide stable URLs for versioned releases
    url = "https://web.archive.org/web/${snapshot}/https://www.mothersruin.com/software/downloads/SuspiciousPackage.dmg";
    hash = "sha256-SJcXqQR/di3T8K3uNKv00QkLsmDGJNU9NQEIpDSqYJM=";
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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";
  doInstallCheck = true;

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

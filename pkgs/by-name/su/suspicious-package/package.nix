{
  lib,
  fetchurl,
  stdenv,
  undmg,
  versionCheckHook,
  mrs-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "suspicious-package";
  version = "4.6";

  src = fetchurl {
    url = "https://www.mothersruin.com/software/archives/SuspiciousPackage-${finalAttrs.version}.dmg";
    hash = "sha256-SJcXqQR/di3T8K3uNKv00QkLsmDGJNU9NQEIpDSqYJM=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Suspicious Package.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Suspicious Package.app" "$out/bin"
    cp -R "." "$out/Applications/Suspicious Package.app"
    ln -s "../Applications/Suspicious Package.app/Contents/SharedSupport/spkg" "$out/bin"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript.command = [
    (lib.getExe mrs-update-script)
    "SuspiciousPackage"
    ./package.nix
  ];

  meta = {
    description = "Toolkit for analysing macOS packages";
    homepage = "https://www.mothersruin.com/software/SuspiciousPackage/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "spkg";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

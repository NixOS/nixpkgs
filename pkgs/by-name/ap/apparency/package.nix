{
  lib,
  fetchurl,
  stdenv,
  undmg,
  versionCheckHook,
  mrs-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apparency";
  version = "2.3";

  src = fetchurl {
    url = "https://www.mothersruin.com/software/archives/Apparency-${finalAttrs.version}.dmg";
    hash = "sha256-QaP7Ll5ZK0QVHPFzDPmV8rd0XmY3Ie0VPBDXJEDMECU=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Apparency.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Apparency.app" "$out/bin"
    cp -R "." "$out/Applications/Apparency.app"
    ln -s "../Applications/Apparency.app/Contents/MacOS/appy" "$out/bin"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript.command = [
    (lib.getExe mrs-update-script)
    "Apparency"
    ./package.nix
  ];

  meta = {
    description = "Toolkit for analysing macOS applications";
    homepage = "https://www.mothersruin.com/software/Apparency/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "appy";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

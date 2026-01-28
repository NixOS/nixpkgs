{
  lib,
  fetchurl,
  stdenv,
  undmg,
  versionCheckHook,
  mrs-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "archaeology";
  version = "1.4";

  src = fetchurl {
    url = "https://www.mothersruin.com/software/archives/Archaeology-${finalAttrs.version}.dmg";
    hash = "sha256-3LIguYn2nGVMaWbHe+PlDZTMzgflGYcx6GSa+K9X/qg=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Archaeology.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Archaeology.app" "$out/bin"
    cp -R "." "$out/Applications/Archaeology.app"
    ln -s "../Applications/Archaeology.app/Contents/MacOS/trowel" "$out/bin"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript.command = [
    (lib.getExe mrs-update-script)
    "Archaeology"
    ./package.nix
  ];

  meta = {
    description = "Tool for digging into binary files on macOS";
    homepage = "https://www.mothersruin.com/software/Archaeology/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "trowel";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

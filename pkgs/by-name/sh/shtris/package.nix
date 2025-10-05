{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shtris";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "ContentsViewer";
    repo = "shtris";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lAuDM6461fR+i3KkgcCcytRT6llSj0kEoqK6N8Q3kVI=";
  };

  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    install --mode=555 -D --target-directory=$out/bin shtris

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pure shell script (sh) that implements the Tetris game following the Tetris Guideline (2009)";
    homepage = "https://github.com/ContentsViewer/shtris";
    changelog = "https://github.com/ContentsViewer/shtris/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "shtris";
  };
})

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "matrix-alertmanager-receiver";
  version = "2025.7.23";

  src = fetchFromGitHub {
    owner = "metio";
    repo = "matrix-alertmanager-receiver";
    tag = finalAttrs.version;
    hash = "sha256-DkltZsWcCFLMDzTMxDv+amwbTVNHxpQVBtgpnTJOFsU=";
  };

  vendorHash = "sha256-6N0G0JGFp+dIUyTFHwpp526QmVZlp071NX+H6CB0uVE=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-X main.matrixAlertmanagerReceiverVersion=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Alertmanager client that forwards alerts to a Matrix room";
    homepage = "https://github.com/metio/matrix-alertmanager-receiver";
    changelog = "https://github.com/metio/matrix-alertmanager-receiver/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "matrix-alertmanager-receiver";
  };
})

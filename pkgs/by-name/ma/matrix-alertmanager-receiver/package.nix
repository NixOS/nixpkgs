{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "matrix-alertmanager-receiver";
  version = "2025.8.20";

  src = fetchFromGitHub {
    owner = "metio";
    repo = "matrix-alertmanager-receiver";
    tag = finalAttrs.version;
    hash = "sha256-7mKpS80Iw35F+YiQujh80wGIjsxwcCEs8lDGLdq1v3U=";
  };

  vendorHash = "sha256-Y43bmnY9E9Mq3yjJ5XO+Ox+jjUmD2IB+SYdyn4IeXE4=";

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

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "matrix-alertmanager-receiver";
  version = "2026.6.17";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "metio";
    repo = "matrix-alertmanager-receiver";
    tag = finalAttrs.version;
    hash = "sha256-vwmLSl09tzpn4hc8+d5l00D93QBsX/y0/403kuNg/SQ=";
  };

  vendorHash = "sha256-Umn+V+yqAUf0dmUW8p1Luh+hcVTqOTA0rmQyE0KmBZA=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-X main.matrixAlertmanagerReceiverVersion=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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

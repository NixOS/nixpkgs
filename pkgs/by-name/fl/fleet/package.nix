{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "fleet";
  version = "4.67.1";

  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    tag = "fleet-v${finalAttrs.version}";
    hash = "sha256-cZ0YTFcyPt7NMZUDZCdlVPTuhwRy7mTp7JCdINqiwOM=";
  };
  vendorHash = "sha256-gFAotYho18Jn8MaFK6ShoMA1VLXVENcrASvHWZGFOFg=";

  subPackages = [
    "cmd/fleet"
  ];

  ldflags = [
    "-X github.com/fleetdm/fleet/v4/server/version.appName=fleet"
    "-X github.com/fleetdm/fleet/v4/server/version.version=${finalAttrs.version}"
  ];

  doCheck = true;
  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    homepage = "https://github.com/fleetdm/fleet";
    changelog = "https://github.com/fleetdm/fleet/releases/tag/fleet-v${finalAttrs.version}";
    description = "CLI tool to launch Fleet server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      asauzeau
    ];
    mainProgram = "fleet";
  };
})

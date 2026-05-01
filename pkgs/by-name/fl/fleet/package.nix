{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  versionCheckHook,
}:

buildGo126Module (finalAttrs: {
  pname = "fleet";
  version = "4.81.0";
  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    tag = "fleet-v${finalAttrs.version}";
    hash = "sha256-LPbMcaQ3YIfh5qwIBB7BwJFgMPurCJudrOzUPm5+VcM=";
  };

  vendorHash = "sha256-kudomUa5c0OJA2LgqLQ2Az0mDH/s9go3jHdyeALGgs8=";

  subPackages = [
    "cmd/fleet"
  ];

  ldflags = [
    "-X github.com/fleetdm/fleet/v4/server/version.appName=fleet"
    "-X github.com/fleetdm/fleet/v4/server/version.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://github.com/fleetdm/fleet";
    changelog = "https://github.com/fleetdm/fleet/releases/tag/fleet-v${finalAttrs.version}";
    description = "CLI tool to launch Fleet server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      asauzeau
      lesuisse
    ];
    mainProgram = "fleet";
  };
})

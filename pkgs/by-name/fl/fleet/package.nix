{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  versionCheckHook,
}:

buildGo126Module (finalAttrs: {
  pname = "fleet";
  version = "4.82.2";
  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    tag = "fleet-v${finalAttrs.version}";
    hash = "sha256-Cbn7phhaDcpYm3nV8nLb/2QVQl9mhsRfHa6GG59MNcA=";
  };

  vendorHash = "sha256-hgo+j2+gE0ArGRRvxC/0jcpv0Bp3hvBRO7Wl+9xl8io=";

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

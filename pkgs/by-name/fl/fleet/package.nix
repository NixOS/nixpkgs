{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "fleet";
  version = "4.78.0";

  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    tag = "fleet-v${finalAttrs.version}";
    hash = "sha256-iUgOBF3vPfr3VCfUc+pASith7R6TA29AuWKCJfbHbQw=";
  };
  vendorHash = "sha256-EwPbZLcqJV5J7ieoQwAJLIn4wwMlwZoTtWaXgvY3pR0=";

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

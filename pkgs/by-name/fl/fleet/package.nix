{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "fleet";
  version = "4.76.2";

  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    tag = "fleet-v${finalAttrs.version}";
    hash = "sha256-607icoLtr3pukMhHzJesFyUgZQb9X0140bX6XY44wu8=";
  };
  vendorHash = "sha256-pCmMGPOTVFImVVzaB1OMvTivh5mxBrgI8EtAkr5U2Jc=";

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

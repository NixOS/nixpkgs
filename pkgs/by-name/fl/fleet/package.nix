{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "fleet";
<<<<<<< HEAD
  version = "4.77.0";
=======
  version = "4.76.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    tag = "fleet-v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-3GrEjXNHts4qEjv8GhQSwAtcC6/I94SWbr6D4aPXW5c=";
  };
  vendorHash = "sha256-DXCfuEGMmcbVcV2LBa6oPMPDtkbkomdgbV4LlMV9qe8=";
=======
    hash = "sha256-DWrErGFKhhAP+qePYz5VJ26dySMOicGkHEN16J9qOx4=";
  };
  vendorHash = "sha256-VLxhlzuQqt/jtUwllCutj2CO2tXWFgLRpU2mGtZM6RE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

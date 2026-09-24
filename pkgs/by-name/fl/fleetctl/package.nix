{
  lib,
  buildGoModule,
  fleet,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "fleetctl";

  inherit (fleet) version src vendorHash;

  subPackages = [
    "cmd/fleetctl"
  ];

  ldflags = [
    "-X github.com/fleetdm/fleet/v4/server/version.appName=fleetctl"
    "-X github.com/fleetdm/fleet/v4/server/version.version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  # Try to access /var/empty/.goquery/history subfolders
  doCheck = !stdenv.hostPlatform.isDarwin;
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    homepage = "https://github.com/fleetdm/fleet";
    changelog = "https://github.com/fleetdm/fleet/releases/tag/fleet-v${finalAttrs.version}";
    description = "CLI tool for managing Fleet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lesuisse
    ];
    mainProgram = "fleetctl";
  };
})

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  stdenv,
}:

buildGoModule rec {
  pname = "fleectl";
  version = "4.67.1";

  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    tag = "fleet-v${version}";
    hash = "sha256-shaOPK7BbIDARopzGehlIA6aPdRiFRP9hrFRNO3kfGA=";
  };
  vendorHash = "sha256-UkdHwjCcxNX7maI4QClLm5WWaLXwGlEu80eZXVoYy60=";

  subPackages = [
    "cmd/fleetctl"
  ];

  ldflags = [
    "-X github.com/fleetdm/fleet/v4/server/version.appName=${pname}"
    "-X github.com/fleetdm/fleet/v4/server/version.version=${version}"
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];

  # Try to access /var/empty/.goquery/history subfolders
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    homepage = "https://github.com/fleetdm/fleet";
    changelog = "https://github.com/fleetdm/fleet/releases/tag/fleet-v${version}";
    description = "CLI tool for managing Fleet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lesuisse
    ];
    mainProgram = "fleetctl";
  };
}

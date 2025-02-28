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
  version = "4.64.1";

  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    tag = "fleet-v${version}";
    hash = "sha256-cZ0YTFcyPt7NMZUDZCdlVPTuhwRy7mTp7JCdINqiwOM=";
  };
  vendorHash = "sha256-gFAotYho18Jn8MaFK6ShoMA1VLXVENcrASvHWZGFOFg=";

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

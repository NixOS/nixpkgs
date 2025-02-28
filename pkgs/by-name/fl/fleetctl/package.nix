{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  fleetctl,
}:

buildGoModule rec {
  pname = "fleectl";
  version = "4.64.1";

  src = fetchFromGitHub {
    owner = "fleetdm";
    repo = "fleet";
    rev = "fleet-v${version}";
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

  preCheck = ''
    # Workaround tests attempting to write in /homeless-shelter/.fleet/config
    export HOME="$(mktemp -d)"
  '';

  passthru.tests.version = testers.testVersion { package = fleetctl; };

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

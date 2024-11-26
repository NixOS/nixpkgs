{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gh-ost,
}:

buildGoModule rec {
  pname = "gh-ost";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-ost";
    rev = "v${version}";
    hash = "sha256-dTz4w+OJXe2+ygsYsQ9tanDyaMXvdh8W3d8xpjQMapI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.AppVersion=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = gh-ost;
  };

  meta = with lib; {
    description = "Triggerless online schema migration solution for MySQL";
    homepage = "https://github.com/github/gh-ost";
    license = licenses.mit;
    mainProgram = "gh-ost";
  };
}

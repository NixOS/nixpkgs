{ lib
, buildGoPackage
, docker
, docker-compose
, fetchFromGitHub
, testers
, ddev }:

buildGoPackage rec {
  pname = "ddev";
  version = "1.21.4";
  goPackagePath = "github.com/drud/ddev";

  src = fetchFromGitHub {
    owner = "drud";
    repo = pname;
    rev = "v${version}";
    sha256 = "XmvknKHVN/qebJfdX2bL+CZ/czZ2H0OFJz7/ofySoeU=";
  };

  vendorHash = null;

  ldflags = [
    "-s" "-w"
    "-X github.com/drud/ddev/pkg/versionconstants.DdevVersion=${src.rev}"
  ];

  buildInputs = [
    docker
    docker-compose
  ];

  passthru.tests.version = testers.testVersion {
    package = ddev;
    command = "HOME=$(mktemp -d) ddev --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Docker-based local PHP + Node.js web development environments";
    homepage = "https://ddev.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jgonyea ];
  };
}

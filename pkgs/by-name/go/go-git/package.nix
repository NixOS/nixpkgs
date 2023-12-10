{ buildGoModule
, fetchFromGitHub
, lib
, testers
, go-git
}:

buildGoModule rec {
  pname = "go-git";
  version = "5.11.0";

  src = fetchFromGitHub {
    owner = "go-git";
    repo = "go-git";
    rev = "v${version}";
    hash = "sha256-Yv66aYs2Pkl1qj/+oknTJtd3ez5y9MI2FE2dNJwxo3o=";
  };

  vendorHash = "sha256-bmbv/9MWh6c1VZ/BPe+GDUpMlc4KPi4VQmcS9Xggc8s=";

  modRoot = "cli/go-git";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = go-git;
    command = "go-git version";
  };

  meta = with lib;  {
    description = "A highly extensible Git implementation in pure Go";
    homepage = "https://github.com/go-git/go-git";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "go-git";
  };
}

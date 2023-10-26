{ lib
, buildGoModule
, fetchFromGitHub
, testers
, distribution
}:

buildGoModule rec {
  pname = "distribution";
  version = "3.0.0-alpha.1";

  src = fetchFromGitHub {
    owner = "distribution";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-reguAtBkEC9OMUTdCtFY6l0fkk28VoA0IlPcQ0sz84I=";
  };

  vendorHash = null;

  subPackages = [ "cmd/registry" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/distribution/distribution/v${lib.versions.major version}/version.Version=${version}"
  ];

  tags = [ "include_gcs" ];

  passthru.tests.version = testers.testVersion {
    package = distribution;
  };

  meta = with lib; {
    homepage = "https://github.com/distribution/distribution";
    changelog = "https://github.com/distribution/distribution/releases/tag/v${version}";
    description = "The toolkit to pack, ship, store, and deliver container content";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "registry";
  };
}

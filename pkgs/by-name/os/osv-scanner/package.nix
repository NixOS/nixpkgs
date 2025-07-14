{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  osv-scanner,
}:

buildGoModule rec {
  pname = "osv-scanner";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "osv-scanner";
    tag = "v${version}";
    hash = "sha256-jYcyzaUjIxuj4VoindgoAGbXVnAU6EgZW8eIu7kBDNM=";
  };

  vendorHash = "sha256-7/y1woEnZyIlE6j/I/+dA9jvW1W4946DjOJwR7rWTFs=";

  subPackages = [
    "cmd/osv-scanner"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/google/osv-scanner/internal/version.OSVVersion=${version}"
    "-X=main.commit=n/a"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  # Tests require network connectivity to query https://api.osv.dev.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = osv-scanner;
  };

  meta = {
    description = "Vulnerability scanner written in Go which uses the data provided by https://osv.dev";
    mainProgram = "osv-scanner";
    homepage = "https://github.com/google/osv-scanner";
    changelog = "https://github.com/google/osv-scanner/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      stehessel
      urandom
    ];
  };
}

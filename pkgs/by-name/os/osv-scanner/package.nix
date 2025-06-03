{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  osv-scanner,
}:

buildGoModule rec {
  pname = "osv-scanner";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "osv-scanner";
    tag = "v${version}";
    hash = "sha256-x2lQqBjNbX+EhtnK6r3YpZX5yAadLMUKfypxsGTB5s4=";
  };

  vendorHash = "sha256-eN5KJWubE+NptdncfVPyglb5SS76Eh7jlrajcjBU8YI=";

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

  meta = with lib; {
    description = "Vulnerability scanner written in Go which uses the data provided by https://osv.dev";
    mainProgram = "osv-scanner";
    homepage = "https://github.com/google/osv-scanner";
    changelog = "https://github.com/google/osv-scanner/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      stehessel
      urandom
    ];
  };
}

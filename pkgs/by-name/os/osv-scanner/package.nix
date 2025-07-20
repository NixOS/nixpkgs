{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  osv-scanner,
}:

buildGoModule rec {
  pname = "osv-scanner";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "osv-scanner";
    tag = "v${version}";
    hash = "sha256-Xr+16wG/iC4SxytfpjFDd3eKvINtCTMTECh3//wFHtY=";
  };

  vendorHash = "sha256-+Ad4XiD4npaATUybVym1Pr+NwgjYDGNTGWdQEcgjWsI=";

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

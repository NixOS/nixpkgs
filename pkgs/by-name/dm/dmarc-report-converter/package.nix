{
  lib,
  buildGoModule,
  dmarc-report-converter,
  fetchFromGitHub,
  testers,
}:

buildGoModule rec {
  pname = "dmarc-report-converter";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "tierpod";
    repo = "dmarc-report-converter";
    rev = "v${version}";
    hash = "sha256-j1uFPCyxLqO3BMxl/02wILj5HGag9qjxCTB8ZxZHEGo=";
  };

  vendorHash = null;

  checkFlags = [ "-mod=vendor ./cmd/... ./pkg/..." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion { package = dmarc-report-converter; };

  meta = {
    description = "Convert DMARC report files from xml to human-readable formats";
    homepage = "https://github.com/tierpod/dmarc-report-converter";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Nebucatnetzer ];
    mainProgram = "dmarc-report-converter";
  };
}

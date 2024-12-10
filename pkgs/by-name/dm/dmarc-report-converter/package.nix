{
  lib,
  buildGoModule,
  dmarc-report-converter,
  fetchFromGitHub,
  runCommand,
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

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests = {
    simple = runCommand "dmarc-report-converter-test" { } ''
      ${dmarc-report-converter}/bin/dmarc-report-converter -h > $out
    '';
  };

  meta = with lib; {
    description = "Convert DMARC report files from xml to human-readable formats";
    homepage = "https://github.com/tierpod/dmarc-report-converter";
    license = licenses.mit;
    maintainers = with maintainers; [ Nebucatnetzer ];
    mainProgram = "dmarc-report-converter";
  };
}

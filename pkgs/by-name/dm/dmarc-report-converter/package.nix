{ lib
, buildGoModule
, dmarc-report-converter
, fetchFromGitHub
, runCommand
}:

buildGoModule rec {
  pname = "dmarc-report-converter";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "tierpod";
    repo = "dmarc-report-converter";
    rev = "v${version}";
    hash = "sha256-TqvAqMZEXhMO3/0VNY3Mr/E15QQbucuKyG95j2jWU5g=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests = {
    simple = runCommand "${pname}-test" { } ''
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

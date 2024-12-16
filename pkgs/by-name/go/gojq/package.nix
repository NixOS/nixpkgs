{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gojq,
}:

buildGoModule rec {
  pname = "gojq";
  version = "0.12.17";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zJkeghN3btF/fZZeuClHV1ndB/2tTTMljEukMYe7UWU=";
  };

  vendorHash = "sha256-ZC0byawZLBwId5GcAgHXRdEOMUSAv4wDNHFHLrbhB+I=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = gojq;
  };

  meta = with lib; {
    description = "Pure Go implementation of jq";
    homepage = "https://github.com/itchyny/gojq";
    changelog = "https://github.com/itchyny/gojq/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "gojq";
  };
}

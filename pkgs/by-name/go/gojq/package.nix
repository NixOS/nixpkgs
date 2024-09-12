{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gojq,
}:

buildGoModule rec {
  pname = "gojq";
  version = "0.12.16";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lCNh0J0vVvSJaNE9fu3X83YRZlWHOI4rQwmrGJDQWzk=";
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

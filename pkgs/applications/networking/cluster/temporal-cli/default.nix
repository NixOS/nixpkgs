{ lib, fetchFromGitHub, buildGoModule, testers, temporal-cli }:

buildGoModule rec {
  pname = "temporal-cli";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "tctl";
    rev = "v${version}";
    sha256 = "sha256-KLcCFQJlFeioIhqrbkhgoNPcbAYvy1ESG8x9Y/I7+nw=";
  };

  vendorSha256 = "sha256-kczmoP32/V0HHeC3Mr+giuMB+McVTNeC2F+t1ohY4/U=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = temporal-cli;
  };

  meta = with lib; {
    description = "Temporal CLI";
    homepage = "https://temporal.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "tctl";
  };
}

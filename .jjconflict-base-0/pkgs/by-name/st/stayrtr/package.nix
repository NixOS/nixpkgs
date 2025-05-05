{
  lib,
  fetchFromGitHub,
  buildGoModule,
  stayrtr,
  testers,
}:

buildGoModule rec {
  pname = "stayrtr";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = "stayrtr";
    rev = "v${version}";
    hash = "sha256-QdPp+AHOVn/L4lArhwUNNu3OP2ALEFzs/hVnfSxaEbg=";
  };
  vendorHash = "sha256-m1CHpmTUQVkBjkjg2bjl9llU1Le1GLRKKLGT4h7MbnE=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = stayrtr;
  };

  meta = with lib; {
    changelog = "https://github.com/bgp/stayrtr/releases/tag/v${version}";
    description = "RPKI-To-Router server implementation in Go";
    homepage = "https://github.com/bgp/stayrtr/";
    license = licenses.bsd3;
    mainProgram = "stayrtr";
    maintainers = with maintainers; [ _0x4A6F ];
  };
}

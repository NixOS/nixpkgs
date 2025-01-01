{
  lib,
  fetchFromGitHub,
  buildGoModule,
  stayrtr,
  testers,
}:

buildGoModule rec {
  pname = "stayrtr";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = "stayrtr";
    rev = "v${version}";
    hash = "sha256-uNZe3g8hs9c0uXrkWSTA+e/gziOpWqx5oFIJ2ZPgEzU=";
  };
  vendorHash = "sha256-0PtQzwBhUoASUMnAAVZ4EIDmqIEaH0nct2ngyIkR+Qg=";

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

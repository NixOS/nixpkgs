{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "scip-go";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip-go";
    rev = "v${version}";
    hash = "sha256-qHGJ6yD3mnhHnu/KOShFb7Gu31jBPtKiEjAkaRlWJpE=";
  };

  vendorHash = "sha256-E/1ubWGIx+sGC+owqw4nOkrwUFJfgTeqDNpH8HCwNhA=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = with lib; {
    description = "SCIP (SCIP Code Intelligence Protocol) indexer for Golang";
    homepage = "https://github.com/sourcegraph/scip-go/tree/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "scip-go";
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scip-go";
  version = "0.1.22";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip-go";
    rev = "v${version}";
    hash = "sha256-1vu6+0CMQwju+Ym0iYXqVktwfJtZFWbn7aOK/w5pVq4=";
  };

  vendorHash = "sha256-E/1ubWGIx+sGC+owqw4nOkrwUFJfgTeqDNpH8HCwNhA=";

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  meta = with lib; {
    description = "SCIP (SCIP Code Intelligence Protocol) indexer for Golang";
    homepage = "https://github.com/sourcegraph/scip-go/tree/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "scip-go";
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "scip-go";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip-go";
    rev = "v${version}";
    hash = "sha256-qzLDqHnZpJtdBZa/YOLZCiS+V52a1Lxc0TLsfSeRCG8=";
  };

  vendorHash = "sha256-J/97J/VXmQAYHu1qr9KiTUrB6/SVFcahihRatCKgaD8=";

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

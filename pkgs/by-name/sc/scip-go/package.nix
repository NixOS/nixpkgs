{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scip-go";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip-go";
    rev = "v${version}";
    hash = "sha256-yRYNct1Ok7E57iB01u33QS7ok1kjv6U/7Hm4s/eKKOo=";
  };

  vendorHash = "sha256-R+0E+BnE912vgqUqaaP2dlbbPyJuaCiNxRcedNKGODU=";

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

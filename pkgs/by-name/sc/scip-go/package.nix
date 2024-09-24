{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scip-go";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip-go";
    rev = "v${version}";
    hash = "sha256-2UKiPKeGDkNiI96RieYWaJygz/ZqfdcBmm9PCuby7qQ=";
  };

  vendorHash = "sha256-UID2mLrkY86k5Ms0cDgIsZR8s6h4TVwRLvLtoLXAXl4=";

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

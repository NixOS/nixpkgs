{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "scip-go";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QtfGiMRrGHgL1VHLMX9icXkY/jv567On3xe/dYmoaQI=";
  };

  vendorHash = "sha256-aKOjU6LhixVpMW2JUkI++jjd4eQbv3w4apBjLbfqpvw=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = {
    description = "SCIP (SCIP Code Intelligence Protocol) indexer for Golang";
    homepage = "https://github.com/sourcegraph/scip-go/tree/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "scip-go";
  };
})

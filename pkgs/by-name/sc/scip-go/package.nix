{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "scip-go";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "scip-code";
    repo = "scip-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/Njx+rYPIZiK0tHMJjZuG02o/1vvukDriytuD7kOawI=";
  };

  vendorHash = "sha256-zz0fvED5QBNcexP63J5UF9Yy4xefkHUyLcOIRrpN4IA=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = {
    description = "SCIP (SCIP Code Intelligence Protocol) indexer for Golang";
    homepage = "https://github.com/scip-code/scip-go/tree/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "scip-go";
  };
})

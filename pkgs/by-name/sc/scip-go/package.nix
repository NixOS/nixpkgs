{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "scip-go";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "scip-code";
    repo = "scip-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cl9GwCjysTit5nPG1uivEbz1HDaClFvYRVwutQ4W9AY=";
  };

  vendorHash = "sha256-5pQSrYS1SU2cwaWiGcYlVHm2pQIY68Is+F8611wNNXI=";

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

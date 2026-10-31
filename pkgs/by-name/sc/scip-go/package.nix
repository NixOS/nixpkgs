{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "scip-go";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "scip-code";
    repo = "scip-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xmC0CW7c0OLeUbTrPmV5OLeNI1FLQlRrDOrc8WiMTIs=";
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

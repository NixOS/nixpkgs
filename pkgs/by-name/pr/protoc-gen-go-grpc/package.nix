{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-go-grpc";
  version = "1.6.1";
  modRoot = "cmd/protoc-gen-go-grpc";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-go";
    rev = "cmd/protoc-gen-go-grpc/v${finalAttrs.version}";
    hash = "sha256-s6GZ9K0Wy18YF1RBL0RGDCbtCfAV2bskq6DNXwyorgg=";
  };

  vendorHash = "sha256-+D3prb03c/Vgm+p3CxCZw14UMCvrDc1Cllzn1znZAE0=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };
  passthru.updateScript = ./update.py;

  meta = {
    description = "Go language implementation of gRPC. HTTP/2 based RPC";
    homepage = "https://grpc.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "protoc-gen-go-grpc";
  };
})

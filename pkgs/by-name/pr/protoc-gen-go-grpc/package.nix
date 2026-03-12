{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-go-grpc";
  version = "1.6.0";
  modRoot = "cmd/protoc-gen-go-grpc";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-go";
    rev = "cmd/protoc-gen-go-grpc/v${finalAttrs.version}";
    hash = "sha256-Ay8X7NoS81ubMtFMrvQINhGAFV/Yh75AXh7/Y9lCJDo=";
  };

  vendorHash = "sha256-s26T7pht7YU1LJIM3edtuPb+KVezqG3m+8CxM+l1ty4=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Go language implementation of gRPC. HTTP/2 based RPC";
    homepage = "https://grpc.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "protoc-gen-go-grpc";
  };
})

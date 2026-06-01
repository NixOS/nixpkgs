{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-go-grpc";
  version = "1.6.2";
  modRoot = "cmd/protoc-gen-go-grpc";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-go";
    rev = "cmd/protoc-gen-go-grpc/v${finalAttrs.version}";
    hash = "sha256-I1sPfKhpCb/GNznKgEE2BZ11vAwJIc6HYf78/nIDRy4=";
  };

  vendorHash = "sha256-lBOgdAE2FT5ZQxfG/ugqxtH5RB3946VJYjm+VUT1AEI=";

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

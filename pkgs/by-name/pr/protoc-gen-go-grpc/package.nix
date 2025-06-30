{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "protoc-gen-go-grpc";
  version = "1.5.1";
  modRoot = "cmd/protoc-gen-go-grpc";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-go";
    rev = "cmd/protoc-gen-go-grpc/v${version}";
    hash = "sha256-PAUM0chkZCb4hGDQtCgHF3omPm0jP1sSDolx4EuOwXo=";
  };

  vendorHash = "sha256-yn6jo6Ku/bnbSX8FL0B/Uu3Knn59r1arjhsVUkZ0m9g=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Go language implementation of gRPC. HTTP/2 based RPC";
    homepage = "https://grpc.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "protoc-gen-go-grpc";
  };
}

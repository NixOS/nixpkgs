{
  buildGoModule,
  fetchFromGitHub,
  lib,
<<<<<<< HEAD
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-go-grpc";
  version = "1.6.0";
=======
}:

buildGoModule rec {
  pname = "protoc-gen-go-grpc";
  version = "1.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  modRoot = "cmd/protoc-gen-go-grpc";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-go";
<<<<<<< HEAD
    rev = "cmd/protoc-gen-go-grpc/v${finalAttrs.version}";
    hash = "sha256-Ay8X7NoS81ubMtFMrvQINhGAFV/Yh75AXh7/Y9lCJDo=";
  };

  vendorHash = "sha256-s26T7pht7YU1LJIM3edtuPb+KVezqG3m+8CxM+l1ty4=";
=======
    rev = "cmd/protoc-gen-go-grpc/v${version}";
    hash = "sha256-PAUM0chkZCb4hGDQtCgHF3omPm0jP1sSDolx4EuOwXo=";
  };

  vendorHash = "sha256-yn6jo6Ku/bnbSX8FL0B/Uu3Knn59r1arjhsVUkZ0m9g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
  ];

<<<<<<< HEAD
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Go language implementation of gRPC. HTTP/2 based RPC";
    homepage = "https://grpc.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "protoc-gen-go-grpc";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

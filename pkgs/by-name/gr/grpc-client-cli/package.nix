{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.22.4";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-xZjVKVbVSchsnAH9DC68IHAqIG6W3DrF5L3Vt+pbyTU=";
  };

  vendorHash = "sha256-XhbmyPZ0GFNRfnHBfMxgSXNLPoCE85e52xcQFhqOrl4=";

  meta = with lib; {
    description = "generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}

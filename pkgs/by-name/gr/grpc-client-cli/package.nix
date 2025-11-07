{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-hi0F3cuN2QMAkzrgk19SuyxEOs2cwDeeBS4NYr38Hzo=";
  };

  vendorHash = "sha256-/lIDY6xjSs5Uk5nw2dExyPQPXNHTJuQR+K8/7PB1kik=";

  meta = with lib; {
    description = "Generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}

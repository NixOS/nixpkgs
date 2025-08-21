{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.22.5";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-e6EqjaPTYC6HSgBqg8F+5tNt7C2/N1mniWxgv6t6y/w=";
  };

  vendorHash = "sha256-BFjJpoAgbG16+26+m3cWxLTg5XCm/2b2vJiEzlbxqxQ=";

  meta = with lib; {
    description = "Generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.21.3";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-c+mwQJczF8BG3NnpZpBZNGzGQxs8/ptApvESQhiUpfA=";
  };

  vendorHash = "sha256-1SRp5NmE+NbRtUZ3s4yL6CJUMs+dlm6oN00gKV9QY0U=";

  meta = with lib; {
    description = "generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}

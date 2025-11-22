{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-MzUUYthXOH+mq7uxjY63k06pifFVUhOnZg8zTujpxxQ=";
  };

  vendorHash = "sha256-K0XnoFbAFdiVm3pDpiw9wuTSIo3NrU7wH1nFJEge9/c=";

  meta = with lib; {
    description = "Generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}

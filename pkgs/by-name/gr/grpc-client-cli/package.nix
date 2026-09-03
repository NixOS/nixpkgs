{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-client-cli";
  version = "1.24.8";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-7tkVEgxYd41uk2zUOVu/pjAOlrZsmRsZb/qCp3w3M4A=";
  };

  vendorHash = "sha256-bZI96h+hHSWBrexM41tPpcc1cPFbY2/s0+ZiO38sycw=";

  meta = {
    description = "Generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with lib.maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = lib.licenses.mit;
  };
})

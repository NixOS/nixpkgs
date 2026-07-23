{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-client-cli";
  version = "1.24.4";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tyvs1rSVKt53I47Mrv66nBzG6X5HxCqQnxI+zqnfyj0=";
  };

  vendorHash = "sha256-MX6jEDf0Iy3WAa3TFIoHkBcn6Gpy6YEc8mGpR6+Md3U=";

  meta = {
    description = "Generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with lib.maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = lib.licenses.mit;
  };
})

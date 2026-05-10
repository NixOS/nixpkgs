{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-client-cli";
  version = "1.24.3";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-M3YhVNu7yx/JAMoNrG/JDEMR7JLLLx02+XchCniYVCU=";
  };

  vendorHash = "sha256-MNl+4PA0hJwWQZwegwVBcUTKWUSfaSdNo4b4lvKRMxM=";

  meta = {
    description = "Generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with lib.maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = lib.licenses.mit;
  };
})

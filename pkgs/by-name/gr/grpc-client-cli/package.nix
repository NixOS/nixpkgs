{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-client-cli";
  version = "1.24.7";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-F7huQ5iVdhwfMvG5GEyg3s2S1I9SiFuBznJpYnxoMsY=";
  };

  vendorHash = "sha256-LjLV3WcmbUU3x1JPC4qennwH3ZQxD96CyhjeFo6H2XY=";

  meta = {
    description = "Generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with lib.maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = lib.licenses.mit;
  };
})

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-client-cli";
  version = "1.25.1";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dYabh9TiEt26u/zTRZJ1h+gxjRZJgOdGW3hk/K+wZ3w=";
  };

  vendorHash = "sha256-PdNv9/DzLNwIvHReyJkqc6ZjgfXNuMAsuw+7LjllfsA=";

  meta = {
    description = "Generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with lib.maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = lib.licenses.mit;
  };
})

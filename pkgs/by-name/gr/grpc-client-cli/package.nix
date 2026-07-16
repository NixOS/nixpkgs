{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-client-cli";
  version = "1.24.6";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5T5Ks98nOQmK3wexnSEZ5q1J9JNGorXpkLGWG5ie6Y4=";
  };

  vendorHash = "sha256-lwat8cp+Tr2KeUc5S2yNZtd3Jadxug0eQKLSsDZlT54=";

  meta = {
    description = "Generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with lib.maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = lib.licenses.mit;
  };
})

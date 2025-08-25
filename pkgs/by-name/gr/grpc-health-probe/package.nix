{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-health-probe";
  version = "0.4.39";
  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-health-probe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZMU3ajBm9b/SzwQZlDKqyU4pGjnoPSD9zdk5gvxuWw8=";
  };
  vendorHash = "sha256-c2RZ7ov/hMBI7QD1HnTLAmPWUdqOKt0Zo74QU9OdXBU=";

  meta = {
    description = "Command-line tool to perform health-checks for gRPC applications";
    homepage = "https://github.com/grpc-ecosystem/grpc-health-probe";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sebimarkgraf ];
  };
})

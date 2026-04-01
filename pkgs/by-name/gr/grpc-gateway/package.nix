{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  grpc-gateway,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-gateway";
  version = "2.28.0";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-93omvHb+b+S0w4D+FGEEwYYDjgumJFDAruc1P4elfvA=";
  };

  vendorHash = "sha256-jVP5zfFPfHeAEApKNJzZwuZLA+DjKgkL7m2DFG72UNs=";

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.commit=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = grpc-gateway;
      command = "protoc-gen-grpc-gateway --version";
      version = "Version ${finalAttrs.version}, commit ${finalAttrs.version}, built at 1970-01-01T00:00:00Z";
    };
    openapiv2Version = testers.testVersion {
      package = grpc-gateway;
      command = "protoc-gen-openapiv2 --version";
      version = "Version ${finalAttrs.version}, commit ${finalAttrs.version}, built at 1970-01-01T00:00:00Z";
    };
  };

  meta = {
    description = "GRPC to JSON proxy generator plugin for Google Protocol Buffers";
    longDescription = ''
      This is a plugin for the Google Protocol Buffers compiler (protoc). It reads
      protobuf service definitions and generates a reverse-proxy server which
      translates a RESTful HTTP API into gRPC. This server is generated according to
      the google.api.http annotations in the protobuf service definitions.
    '';
    homepage = "https://github.com/grpc-ecosystem/grpc-gateway";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ happyalu ];
  };
})

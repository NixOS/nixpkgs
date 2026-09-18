{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "openapi2proto";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "NYTimes";
    repo = "openapi2proto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1F0dBHTi4zlojTLZdv5MwNNlrzG4ryxAHMmOfSRSb0w=";
  };

  vendorHash = "sha256-qsef0ZYxDaVihhybKaaegs9enJqFA4e+N2zk7AcDgV4=";

  subPackages = [ "cmd/openapi2proto" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Tool for generating Protobuf v3 schema and gRPC service definitions from OpenAPI/Swagger specifications";
    homepage = "https://github.com/NYTimes/openapi2proto";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ connerohnesorge ];
    mainProgram = "openapi2proto";
  };
})

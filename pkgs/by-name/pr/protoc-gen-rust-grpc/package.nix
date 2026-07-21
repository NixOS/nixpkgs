{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protoc-gen-rust-grpc";
  version = "0.8.3";

  src = fetchCrate {
    pname = "grpc-compiler";
    inherit (finalAttrs) version;
    hash = "sha256-gt+Qa68N5EkqhCAvU2ISvVPT9vYPXMySad4DCyTVHkQ=";
  };

  cargoHash = "sha256-7PTe7popLS0zYYKv+K4629GkNG1wR/fhGi14a/4pkS0=";

  meta = {
    description = "Protobuf plugin for generating Rust code for gRPC";
    homepage = "https://github.com/stepancheg/grpc-rust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lucperkins ];
    mainProgram = "protoc-gen-rust-grpc";
  };
})

{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-rust-grpc";
  version = "0.8.3";

  src = fetchCrate {
    pname = "grpc-compiler";
    inherit version;
    hash = "sha256-gt+Qa68N5EkqhCAvU2ISvVPT9vYPXMySad4DCyTVHkQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7PTe7popLS0zYYKv+K4629GkNG1wR/fhGi14a/4pkS0=";

  meta = with lib; {
    description = "Protobuf plugin for generating Rust code for gRPC";
    homepage = "https://github.com/stepancheg/grpc-rust";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "protoc-gen-rust-grpc";
  };
}

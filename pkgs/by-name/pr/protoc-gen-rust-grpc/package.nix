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

  cargoHash = "sha256-08xEPc1GaRIYLbIlSRpfBvSQcs16vduJ7v/NDg7Awfs=";

  meta = with lib; {
    description = "Protobuf plugin for generating Rust code for gRPC";
    homepage = "https://github.com/stepancheg/grpc-rust";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "protoc-gen-rust-grpc";
  };
}

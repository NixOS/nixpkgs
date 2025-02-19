{
  fetchCrate,
  lib,
  rustPlatform,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-rust";
  version = "3.5.0";

  src = fetchCrate {
    inherit version;
    pname = "protobuf-codegen";
    hash = "sha256-yGZ4auZHGtcsN6n4/FEzabsSXproyhNTJHIwujt7ijg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cj+/X3soc//lMOmBjfjQT+QhY/EWP92gChiDQ7b2fsM=";

  cargoBuildFlags = [
    "--bin"
    pname
  ];

  nativeBuildInputs = [ protobuf ];

  meta = with lib; {
    description = "Protobuf plugin for generating Rust code";
    mainProgram = "protoc-gen-rust";
    homepage = "https://github.com/stepancheg/rust-protobuf";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}

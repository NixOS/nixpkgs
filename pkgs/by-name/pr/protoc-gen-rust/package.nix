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

  cargoHash = "sha256-RO3kVYkvHw8kwLaRfANtGtz88knjJ8HtmU3i0xgIDMY=";

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

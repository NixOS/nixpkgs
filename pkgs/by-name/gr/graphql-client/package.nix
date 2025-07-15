{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "graphql-client";
  version = "0.13.0";

  src = fetchCrate {
    inherit version;
    crateName = "graphql_client_cli";
    hash = "sha256-eQ+7Ru3au/rDQZtwFDXYyybqC5uFtNBs6cEzX2QSFI4=";
  };

  cargoHash = "sha256-GPUOIDKlxk2P+cPmOPlpz/EM9TCXvHo41+1fQ0xAqto=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "GraphQL tool for Rust projects";
    mainProgram = "graphql-client";
    homepage = "https://github.com/graphql-rust/graphql-client";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ bbigras ];
  };
}

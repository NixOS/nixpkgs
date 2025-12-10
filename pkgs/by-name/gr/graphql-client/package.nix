{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "graphql-client";
  version = "0.15.0";

  src = fetchCrate {
    inherit version;
    crateName = "graphql_client_cli";
    hash = "sha256-kYznUgLe2hg8dOPJQVrl+zZQFAbiSkeHAgxiSiVsHoE=";
  };

  cargoHash = "sha256-Knet/xIBZwbKWQHSVWCGxS+2W1qBRvQqEHhak6wWr94=";

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

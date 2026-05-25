{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "graphql-client";
  version = "0.16.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "graphql_client_cli";
    hash = "sha256-zWNarJDBSnZeFPQnF8nHOkFG8x0UDChi8l79OBNFA6A=";
  };

  cargoHash = "sha256-LYRdK+wOoaJ/qkJoNC+enaqlMfeACDvNA1iyNEgTXCg=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];

  meta = {
    description = "GraphQL tool for Rust projects";
    mainProgram = "graphql-client";
    homepage = "https://github.com/graphql-rust/graphql-client";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ bbigras ];
  };
})

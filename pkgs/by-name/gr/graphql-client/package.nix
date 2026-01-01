{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "graphql-client";
<<<<<<< HEAD
  version = "0.15.0";
=======
  version = "0.13.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchCrate {
    inherit version;
    crateName = "graphql_client_cli";
<<<<<<< HEAD
    hash = "sha256-kYznUgLe2hg8dOPJQVrl+zZQFAbiSkeHAgxiSiVsHoE=";
  };

  cargoHash = "sha256-Knet/xIBZwbKWQHSVWCGxS+2W1qBRvQqEHhak6wWr94=";
=======
    hash = "sha256-eQ+7Ru3au/rDQZtwFDXYyybqC5uFtNBs6cEzX2QSFI4=";
  };

  cargoHash = "sha256-GPUOIDKlxk2P+cPmOPlpz/EM9TCXvHo41+1fQ0xAqto=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];

<<<<<<< HEAD
  meta = {
    description = "GraphQL tool for Rust projects";
    mainProgram = "graphql-client";
    homepage = "https://github.com/graphql-rust/graphql-client";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ bbigras ];
=======
  meta = with lib; {
    description = "GraphQL tool for Rust projects";
    mainProgram = "graphql-client";
    homepage = "https://github.com/graphql-rust/graphql-client";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ bbigras ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

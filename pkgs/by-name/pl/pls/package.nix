{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "pls";
  version = "0.0.1-beta.7";

  src = fetchFromGitHub {
    owner = "pls-rs";
    repo = "pls";
    rev = "v${version}";
    hash = "sha256-X4HGVwBZdDXH5RuBiugEd4I+aXRqZvXoRDZnm8GY3cM=";
  };

  cargoHash = "sha256-d6HfIEROudINn2Jbnc3EEDZCD833FFFeUk6mvlu0ErA=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = {
    changelog = "https://github.com/pls-rs/pls/releases/tag/${src.rev}";
    description = "Prettier and powerful ls";
    homepage = "http://pls.cli.rs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pls";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}

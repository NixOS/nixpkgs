{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "pls";
  version = "0.0.1-beta.6";

  src = fetchFromGitHub {
    owner = "pls-rs";
    repo = "pls";
    rev = "v${version}";
    hash = "sha256-T+OUvupPXg9dEV9GJozEyDLKqBkeH6UFYuSxX2BTZkM=";
  };

  cargoHash = "sha256-bo6tySTgGYO+TedBLGwvk+HZmO0KvJEal/eHGSZlp7c=";

  buildInputs = lib.optionals stdenv.isDarwin [
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

{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "dotenv-linter";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "dotenv-linter";
    repo = "dotenv-linter";
    rev = "v${version}";
    sha256 = "sha256-H4a/JM2CFrELmP4w4vrFxbvmvdTQk8k7g3QjQKm++Uk=";
  };

  cargoHash = "sha256-11u3a4W3vrGJQXjSMcDAS5D9mqG+XJ0L5FYmqqH/McM=";

  meta = with lib; {
    description = "Lightning-fast linter for .env files. Written in Rust";
    mainProgram = "dotenv-linter";
    homepage = "https://dotenv-linter.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ humancalico ];
  };
}

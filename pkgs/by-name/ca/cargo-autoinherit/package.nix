{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-autoinherit";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "mainmatter";
    repo = "cargo-autoinherit";
    rev = "v${version}";
    hash = "sha256-ai2BqBfZlCOA1DIlzZerH71sbUMi6C65FRv5VDU0DPU=";
  };

  cargoHash = "sha256-bPbwUqw2IFwZTi7qFm1BQgGYBAb6OG8QSU8xTdx/1zM=";

  meta = {
    description = "Automatically DRY up your Rust dependencies";
    homepage = "https://github.com/mainmatter/cargo-autoinherit";
    license = with lib.licenses; [
      asl20 # OR
      mit
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "cargo-autoinherit";
  };
}

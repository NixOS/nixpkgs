{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-autoinherit";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "mainmatter";
    repo = "cargo-autoinherit";
    rev = "v${version}";
    hash = "sha256-BuZDCd4SwSYg5eKV61L3RpPVmq5NZDAOc9zOz5QiSNI=";
  };

  cargoHash = "sha256-9hhrVkC1xB2E/vatkiM4PIJyXq+0GDoqlgXZXc8WehU=";

  meta = with lib; {
    description = "Automatically DRY up your Rust dependencies";
    homepage = "https://github.com/mainmatter/cargo-autoinherit";
    license = with licenses; [ asl20 /* OR */ mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "cargo-autoinherit";
  };
}


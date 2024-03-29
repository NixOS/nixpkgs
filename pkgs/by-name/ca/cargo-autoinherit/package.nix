{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-autoinherit";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "mainmatter";
    repo = "cargo-autoinherit";
    rev = "v${version}";
    hash = "sha256-TMRomAWxieM7CpoFISOR5J433CY9WnHbA/FlL2NMQDw=";
  };

  cargoHash = "sha256-8uJZ/ZHb2TnFJqgBsF1HBAWc+MNZoxaxXInp1T3Zd34=";

  meta = with lib; {
    description = "Automatically DRY up your Rust dependencies";
    homepage = "https://github.com/mainmatter/cargo-autoinherit";
    license = with licenses; [ asl20 /* OR */ mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "cargo-autoinherit";
  };
}


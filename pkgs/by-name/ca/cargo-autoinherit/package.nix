{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-autoinherit";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "mainmatter";
    repo = "cargo-autoinherit";
    rev = "v${version}";
    hash = "sha256-A4Ooqt/Cb8yyc4Y9DKZuFEVUux1ot+IVkPsSDylM6G4=";
  };

  cargoHash = "sha256-TUW0DdTVNrFpRaTGWM9XD0kW1CjmSAfWrbZxFGn1jJw=";

  meta = with lib; {
    description = "Automatically DRY up your Rust dependencies";
    homepage = "https://github.com/mainmatter/cargo-autoinherit";
    license = with licenses; [
      asl20 # OR
      mit
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "cargo-autoinherit";
  };
}

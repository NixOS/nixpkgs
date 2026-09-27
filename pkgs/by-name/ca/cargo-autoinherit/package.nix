{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-autoinherit";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "mainmatter";
    repo = "cargo-autoinherit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-A4Ooqt/Cb8yyc4Y9DKZuFEVUux1ot+IVkPsSDylM6G4=";
  };

  cargoHash = "sha256-TUW0DdTVNrFpRaTGWM9XD0kW1CjmSAfWrbZxFGn1jJw=";

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
})

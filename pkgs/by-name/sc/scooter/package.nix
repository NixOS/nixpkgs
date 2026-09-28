{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scooter";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4pekZhk8g4BzyhNqWLocP24bLKpr0kLepRzp+NYfX1I=";
  };

  cargoHash = "sha256-Ac+iCZ2WoRq7yP9YlT9hp0grsMPny/JdYBrdWiSj/L8=";

  # Ensure that only the `scooter` package is built (excluding `xtask`)
  cargoBuildFlags = [
    "--package"
    "scooter"
  ];

  # Many tests require filesystem writes which fail in Nix sandbox
  doCheck = false;

  meta = {
    description = "Interactive find and replace in the terminal";
    homepage = "https://github.com/thomasschafer/scooter";
    changelog = "https://github.com/thomasschafer/scooter/commits/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    mainProgram = "scooter";
  };
})

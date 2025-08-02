{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-machete";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "bnjbvr";
    repo = "cargo-machete";
    rev = "v${version}";
    hash = "sha256-0vlau3leAAonV5E9NAtSqw45eKoZBzHx0BmoEY86Eq8=";
  };

  cargoHash = "sha256-Oht5V9+DS4vDfd9jcxiMG/gySY5IzhbTY+Ozod4kjko=";

  # tests require internet access
  doCheck = false;

  meta = {
    description = "Cargo tool that detects unused dependencies in Rust projects";
    mainProgram = "cargo-machete";
    homepage = "https://github.com/bnjbvr/cargo-machete";
    changelog = "https://github.com/bnjbvr/cargo-machete/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-machete";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "bnjbvr";
    repo = "cargo-machete";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4tzffZeHdhAq6/K1BGkThqT+CBa3rUw+kR7aLwnqZjc=";
  };

  cargoHash = "sha256-ahTvfxYYo3prPKDTalw2f2FPJLsPzGkE/2LCcyuniFY=";

  # tests require internet access
  doCheck = false;

  meta = {
    description = "Cargo tool that detects unused dependencies in Rust projects";
    mainProgram = "cargo-machete";
    homepage = "https://github.com/bnjbvr/cargo-machete";
    changelog = "https://github.com/bnjbvr/cargo-machete/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      chrjabs
    ];
  };
})

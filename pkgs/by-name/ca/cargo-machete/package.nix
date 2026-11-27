{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-machete";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "bnjbvr";
    repo = "cargo-machete";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EwfyIqwoZgxBPrC7OItztT3HWJyls1N/4r05AcC1334=";
  };

  cargoHash = "sha256-Fnje7FbIbfVFpb+UvyKN2P7aoxUGLrmTPsea6nbM8I8=";

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

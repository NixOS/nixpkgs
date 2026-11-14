{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-machete";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "bnjbvr";
    repo = "cargo-machete";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WuqDppm5l5izMBJ+QXiwv5aSz36nfp/MpW6GM3tMnYo=";
  };

  cargoHash = "sha256-G0O0iZ+PNBEza7NFdPSRleOy0mypepzXXm+V4zA1+Bo=";

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

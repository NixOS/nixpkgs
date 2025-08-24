{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-machete";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "bnjbvr";
    repo = "cargo-machete";
    rev = "v${version}";
    hash = "sha256-exET/zBm5sjnrEx++PRgoWaz7lr7AEF+GVOTOZRGbbU=";
  };

  cargoHash = "sha256-vv6QYIkQtrwlXMKPuZ1ZRJkhaN2qDI0x8vSK/bzDipE=";

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Cargo tool that detects unused dependencies in Rust projects";
    mainProgram = "cargo-machete";
    homepage = "https://github.com/bnjbvr/cargo-machete";
    changelog = "https://github.com/bnjbvr/cargo-machete/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}

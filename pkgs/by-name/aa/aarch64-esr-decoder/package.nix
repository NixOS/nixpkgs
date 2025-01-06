{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "aarch64-esr-decoder";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "aarch64-esr-decoder";
    rev = version;
    hash = "sha256-U9i5L3s4oQOIqlECSaKkHxS2Vzr6SY4tIUpvl3+oSl0=";
  };

  cargoHash = "sha256-BdxRvvU3AovlT7QloZ/LlkjRTVCWEsPUj4NkP4gBPsY=";

  meta = {
    description = "Utility for decoding aarch64 ESR register values";
    homepage = "https://github.com/google/aarch64-esr-decoder";
    changelog = "https://github.com/google/aarch64-esr-decoder/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jmbaur ];
    mainProgram = "aarch64-esr-decoder";
  };
}

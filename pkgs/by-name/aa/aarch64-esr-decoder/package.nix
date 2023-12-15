{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "aarch64-esr-decoder";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "aarch64-esr-decoder";
    rev = version;
    hash = "sha256-YdB/8EUeELcKBj8UMbeWFzJ8HeMHvDgrP2qlOJp2dXA=";
  };

  cargoHash = "sha256-P55DiHBUkr6mreGnWET4+TzLkKnVQJ0UwvrGp6BQ304=";

  meta = with lib; {
    description = "A utility for decoding aarch64 ESR register values";
    homepage = "https://github.com/google/aarch64-esr-decoder";
    changelog = "https://github.com/google/aarch64-esr-decoder/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ jmbaur ];
    mainProgram = "aarch64-esr-decoder";
  };
}

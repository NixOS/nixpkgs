{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "aarch64-esr-decoder";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "aarch64-esr-decoder";
    rev = version;
    hash = "sha256-ZpSrz7iwwzNrK+bFTMn5MPx4Zjceao9NKhjAyjuPLWY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xOBJ8QYiWu5vmkRpttN2CXCXi4bNj+qph31hSkDadjI=";

  meta = {
    description = "Utility for decoding aarch64 ESR register values";
    homepage = "https://github.com/google/aarch64-esr-decoder";
    changelog = "https://github.com/google/aarch64-esr-decoder/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jmbaur ];
    mainProgram = "aarch64-esr-decoder";
  };
}

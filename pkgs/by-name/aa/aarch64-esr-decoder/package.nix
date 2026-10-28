{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aarch64-esr-decoder";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "aarch64-esr-decoder";
    tag = finalAttrs.version;
    hash = "sha256-DO/MS/Mt5KBFEEQt9BuJHF1J9UWqDJ3eWKzsw3X75jc=";
  };

  cargoHash = "sha256-pbBIvenBe0+tt3VPuoTtFTDFy6yO5bju0FS2hXJtGZU=";

  meta = {
    description = "Utility for decoding aarch64 ESR register values";
    homepage = "https://github.com/google/aarch64-esr-decoder";
    changelog = "https://github.com/google/aarch64-esr-decoder/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jmbaur ];
    mainProgram = "aarch64-esr-decoder";
  };
})

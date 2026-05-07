{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-lock";
  version = "11.0.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-l8B98ycfC17vUY29BbFoucGeAn8mapchCvjdMCNhKqc=";
  };

  cargoHash = "sha256-l76udCsgloW5tZ8TgNMOT47un2Epun0B3UjaHCWdZjE=";

  buildFeatures = [ "cli" ];

  meta = {
    description = "Self-contained Cargo.lock parser with graph analysis";
    mainProgram = "cargo-lock";
    homepage = "https://github.com/rustsec/rustsec/tree/main/cargo-lock";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-lock/v${finalAttrs.version}/cargo-lock/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})

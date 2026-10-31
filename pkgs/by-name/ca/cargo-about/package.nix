{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-about";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    tag = finalAttrs.version;
    hash = "sha256-mZyfECnlpYom/XI445DOeUAthqK3HKC+QkkK+5gf0/E=";
  };

  cargoHash = "sha256-//t3ASNljC4rosk5oOmcJy8PZKRYjlQ0euzzAmfiSPQ=";

  buildFeatures = [ "cli" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog = "https://github.com/EmbarkStudios/cargo-about/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      evanjs
      matthiasbeyer
    ];
    mainProgram = "cargo-about";
  };
})

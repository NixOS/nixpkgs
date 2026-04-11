{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-about";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    tag = finalAttrs.version;
    sha256 = "sha256-QbmZIbn/xPZUTXNpUjGuWTjoh8RpsMRuVIfJRO9M3xM=";
  };

  cargoHash = "sha256-oO5Kp5A2v1w6EUwgcHhyagZDIK7a/2d9uTiCoXHuHhY=";

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

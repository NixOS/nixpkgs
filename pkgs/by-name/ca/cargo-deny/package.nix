{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-deny";
  version = "0.19.7";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-deny";
    tag = finalAttrs.version;
    hash = "sha256-hdC8SagsZzdJ4FbBBPOt6/iAq3pHtNcS4xuYccJX56Y=";
  };

  cargoHash = "sha256-2f+RWVTiz0ZBdBKBQfYTojssEHlyVl1mMhfHeulOgXE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # tests require internet access
  doCheck = false;

  meta = {
    description = "Cargo plugin for linting your dependencies";
    mainProgram = "cargo-deny";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    changelog = "https://github.com/EmbarkStudios/cargo-deny/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
      jk
      chrjabs
    ];
  };
})

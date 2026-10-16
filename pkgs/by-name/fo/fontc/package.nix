{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fontc";
  version = "0.6.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-TjbhVkhoIoyp6A33v/QVaNLoHxB5whT/gOlehQTUKxM=";
  };

  cargoHash = "sha256-FLvEgIFgLE++59j5LeCRC4ptgRhAiDF7hani4Yh8kn0=";

  # skip `cargo test` because source code from crates.io doesn't include necessary resources for testing
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wherein we pursue oxidizing fontmake";
    homepage = "https://github.com/googlefonts/fontc";
    changelog = "https://github.com/googlefonts/fontc/releases/tag/fontc-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shiphan ];
    mainProgram = "fontc";
  };
})

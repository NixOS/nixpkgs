{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-apk";
  version = "0.10.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-aA+XxqSlugFa8vN8YIye5nV2f2wLmCMf/cdFjiGRGEY=";
  };

  cargoHash = "sha256-qd8xJz2nJb3R6EAi9GS7UhWK9Esm9eBsm4+rA1DjYPI=";

  meta = {
    description = "Tool for creating Android packages";
    mainProgram = "cargo-apk";
    homepage = "https://github.com/rust-windowing/android-ndk-rs";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ nickcao ];
  };
})

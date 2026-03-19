{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-lock";
  version = "11.0.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Gz459c2IWD19RGBg2TyHbI/VNCelha+R0FeNkAaHksU=";
  };

  cargoHash = "sha256-Kw1LWu/DYfeuf5aMaNslnDyEoaRj0J+yxWs7sKHyWlU=";

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

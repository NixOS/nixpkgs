{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-tally";
  version = "1.0.81";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-PDRqmAkLPuYA8x09Kg7aaQxDA6beBBsSnEI7Ko9Bfh8=";
  };

  cargoHash = "sha256-t62WDLBjkP7EkO/AdkMkGnRoq60SdtfiU2qrBDbKVWI=";

  meta = {
    description = "Graph the number of crates that depend on your crate over time";
    mainProgram = "cargo-tally";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${finalAttrs.version}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})

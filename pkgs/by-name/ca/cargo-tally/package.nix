{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-tally";
  version = "1.0.75";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-X3VJfzIXxwHPu31wYo79Ei6+S970UHlPPTADlB4CwjI=";
  };

  cargoHash = "sha256-86V96i5DvydXu1mzxRP6hWW3TA25piubcGRYVJIi/x0=";

  meta = {
    description = "Graph the number of crates that depend on your crate over time";
    mainProgram = "cargo-tally";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})

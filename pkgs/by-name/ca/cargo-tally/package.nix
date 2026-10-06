{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-tally";
  version = "1.0.78";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-+zAi4Cgfi7rO0OcWv50Y7q3NiebLrdaPUR/SFKerrRA=";
  };

  cargoHash = "sha256-iYb2K70+jVJTdS65bZmcxE4eJstcqtx10NisU7NaW/Q=";

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

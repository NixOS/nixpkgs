{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-tally";
  version = "1.0.80";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-VdqjXqHn922SnIYz6DKgyIzYHNDo9X2KMJ0Ub299Jcc=";
  };

  cargoHash = "sha256-GPThHZUfj6xSohgkMniHm7lTYNlsgQRdJ7tcBKTNk2I=";

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

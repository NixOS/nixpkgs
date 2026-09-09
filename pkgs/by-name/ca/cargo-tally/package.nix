{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-tally";
  version = "1.0.77";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-bkikJU5qyq+6+PYCJrEmdZHIsPGz4prOt6g69hOIZ8o=";
  };

  cargoHash = "sha256-hVkQdWOhM/R0hcrtzvlSFtw51jSRKNPmhDCNUbiK3rI=";

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

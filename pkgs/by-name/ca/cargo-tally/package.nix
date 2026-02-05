{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.73";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-aYVo/mI4YoohwxXoIL9vpuPN526sPnQMV1PnUqJEO2U=";
  };

  cargoHash = "sha256-+TIYJn0BvFBmhVkldOTtAvQv5Uj5sLsJ4OGNH3ic8lU=";

  meta = {
    description = "Graph the number of crates that depend on your crate over time";
    mainProgram = "cargo-tally";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
}

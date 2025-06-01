{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.64";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5eRDKGocAdK8jyDrbEOEQxS4ykneTDbDfXvVU/AH4f8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9p5IfGfOWyDanaUt1h6bnq4mDxp+VdU4scNdWGRiWYE=";

  meta = with lib; {
    description = "Graph the number of crates that depend on your crate over time";
    mainProgram = "cargo-tally";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${version}";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}

{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.65";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-cvMB/hMq0LCfuXHX1Gg0c3i69T1uQWKIddUru5dcg7g=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ReVLeyQY08i1sH6IujeLK8y1+PfPm8BoYInzbTHHnlw=";

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
      figsoda
      matthiasbeyer
    ];
  };
}

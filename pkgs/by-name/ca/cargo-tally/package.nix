{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.66";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-PC/gscMO7oYcsd/cVcP5WZYweWRsh23Z7Do/qeGjAOc=";
  };

  cargoHash = "sha256-00J8ip2fr/nphY0OXVOLKv7gaHitMziwsdJ4YBaYxog=";

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

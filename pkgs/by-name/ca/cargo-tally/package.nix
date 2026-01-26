{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.72";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-YkjRCP6VAp2Az0iM5HIG984ScJ3b3iKm34j4YuIs0kQ=";
  };

  cargoHash = "sha256-SAO1VqlYzySIiBV3j6PCo7gknekmULpG/Two/8R0pv4=";

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

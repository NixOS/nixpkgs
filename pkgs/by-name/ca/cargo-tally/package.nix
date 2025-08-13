{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.67";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Jt7pEpy06xoYWLIMustYvVB81fcGEK7GYvh5ukDUiQ0=";
  };

  cargoHash = "sha256-gXFcsaXaCkX4wQ9/eHr9CUI/r6KEAfZ8HYiDqBRtQeA=";

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

{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.71";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-jJj4aXhGMU5L7Yya65wi022M6lE/nHiyjozptSJcMGg=";
  };

  cargoHash = "sha256-GC4rYaNwTLfbSAojnhZb0vi6FmNiXL6YJ5TEVtQom6M=";

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

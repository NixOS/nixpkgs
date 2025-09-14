{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.69";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ZAayOuuCncjQ3+RGega/aQW/s14QB9541EFB7f6CWxE=";
  };

  cargoHash = "sha256-XLnmx84OP3bwhuRfezczKMJsyc95ClK4yC/RqPe9AB8=";

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

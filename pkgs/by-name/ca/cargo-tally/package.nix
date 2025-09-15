{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.70";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-9KOrnHWro3ZDFl9jl2lZl9/fDUbbMfzGftsV+1HXNfQ=";
  };

  cargoHash = "sha256-7E9KO16LdIIULzxvPMZPPKlOunktYQkVbdnCZmxwlSw=";

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

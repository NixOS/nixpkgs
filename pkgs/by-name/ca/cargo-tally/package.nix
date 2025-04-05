{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.61";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-54Hu7n5KD41aywL8IqhO0k7aR0N7yi3QNNTX1sqvGvE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1Grjj2uaEjr2YKvkd8cxJfUpR8OYqmtuSvIW4tSdIyM=";

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

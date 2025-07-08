{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.72";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-mSzSc72/Y18O9nSoqeU4GQGa9lTwi34ojnIsZg8wBpE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-l4h7DFl9WFB0uARk1P/EAYqAgSiHEEnRXS+h69qaL0Q=";

  meta = with lib; {
    description = "Cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    mainProgram = "cargo-chef";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}

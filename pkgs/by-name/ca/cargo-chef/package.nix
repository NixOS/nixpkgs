{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.71";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ZbbRo+AAlh7sW1HROxHfmnDxchJRWUId3oh5wgPauuQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/VqFs5wzKbnfZRfKERUGjuCj/H+o1iI/ioMPq/FugDo=";

  meta = with lib; {
    description = "Cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    mainProgram = "cargo-chef";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}

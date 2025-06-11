{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  curl,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.47.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-xDMOrL9yyaEEwPhcrkPugVMTyKW4T6X1yE4tN9dmPas=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HhYGc0S/i6KWZsv4E1NTkZb+jdUkcKDP/c0hdVTHJXE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    openssl
  ];

  # Tests fail
  doCheck = false;

  meta = {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    mainProgram = "cargo-public-api";
    homepage = "https://github.com/Enselic/cargo-public-api";
    changelog = "https://github.com/Enselic/cargo-public-api/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}

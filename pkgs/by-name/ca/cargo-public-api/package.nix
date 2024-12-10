{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  curl,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.40.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-FXScN4xOaJOiEm9NV66wsfGOj7up1DPzLK7lMofXL2g=";
  };

  cargoHash = "sha256-v7K62jMGNwIo1XbkWpIXuoNkaRGRAqvZ/c9wdKfY+Xs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    mainProgram = "cargo-public-api";
    homepage = "https://github.com/Enselic/cargo-public-api";
    changelog = "https://github.com/Enselic/cargo-public-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

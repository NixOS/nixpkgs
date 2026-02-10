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
  version = "0.50.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Lg8X0t5u4Mq/eWc0yfuLyn4HlE+j6qSsLE+MFBjBpbk=";
  };

  cargoHash = "sha256-OjuCABObMRkFrTbtV4wpSHzV9Yqmwr/VotmsUW9qUDk=";

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

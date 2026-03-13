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
  version = "0.51.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-fnkoIXv6QYJPYtsLZldOEjOxke6YVDEds3jF5SGZGKE=";
  };

  cargoHash = "sha256-F4s3h+WF/S6sQ9ux28sqNe9+C1I5H9735b+cVuRFjk8=";

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

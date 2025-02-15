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
  version = "0.44.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-DInUd9r2ABvehc/SoJI9VmbfllbYNwwORWSTfsL9EwE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-CcDoGAt3CMDO7NFyx+0Jk2RRvQT+vFWUu0vz40Ogpgo=";

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

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
  version = "0.43.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oAtAfoWJ4YZ9YcU7DQtj6QqF1DSEMOUjauQxqo1a6GA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VcblQw9EZSvV8rw9Krp5ZTXwVdZJe0FqJbqpptkpJfU=";

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

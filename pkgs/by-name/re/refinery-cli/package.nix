{
  fetchCrate,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "refinery-cli";
  version = "0.8.14";

  src = fetchCrate {
    pname = "refinery_cli";
    inherit version;
    hash = "sha256-gHW+5WWzk1H2O5B2sWdl6QcOeUbNvbdZZBD10SmE1GA=";
  };

  # The `time` crate doesn't build on Rust 1.80+
  # https://github.com/NixOS/nixpkgs/issues/332957
  cargoPatches = [ ./time-crate.patch ];

  cargoHash = "sha256-gcPVbKcPkV0H+BpErTokvLKFxpSXhxNoptxOeuhH1FU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Run migrations for the Refinery ORM for Rust via the CLI";
    mainProgram = "refinery";
    homepage = "https://github.com/rust-db/refinery";
    changelog = "https://github.com/rust-db/refinery/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
}

{
  fetchCrate,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "refinery-cli";
  version = "0.9.2";

  src = fetchCrate {
    pname = "refinery_cli";
    inherit (finalAttrs) version;
    hash = "sha256-KBwEefttkIy8+NN16K6qnvOJxEe9DH+oGXuFx2/ziCw=";
  };

  cargoHash = "sha256-PulFXZw/ouaYP7FWWLv7R/hemN4IatXH+2wIBJjd3oc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Run migrations for the Refinery ORM for Rust via the CLI";
    mainProgram = "refinery";
    homepage = "https://github.com/rust-db/refinery";
    changelog = "https://github.com/rust-db/refinery/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
})

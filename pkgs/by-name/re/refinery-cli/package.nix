{
  fetchCrate,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "refinery-cli";
  version = "0.10.0";

  src = fetchCrate {
    pname = "refinery_cli";
    inherit (finalAttrs) version;
    hash = "sha256-fXCzsTWm6z85XrqailzNfJ6DFLyX2YvESH4K720JSgY=";
  };

  cargoHash = "sha256-wi36nJpShKInsZ5LpXJrE00D6V+7YCsfZLBhGIhCN2o=";

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

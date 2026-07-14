{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-chef";
  version = "0.1.77";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-R2on81B11ploV9QwiV5VCvRUCLQWbP21dazNliqkhGA=";
  };

  cargoHash = "sha256-iOZjyqoykCwrNsXN7nMF6deuSSlyD6r2+atxPeNmX2c=";

  meta = {
    description = "Cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    mainProgram = "cargo-chef";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kkharji ];
  };
})

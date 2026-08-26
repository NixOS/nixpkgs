{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-chef";
  version = "0.1.78";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-gFtmKaznJNlmhlCzpHraEdZfDV5fAwYVphJo29qcftw=";
  };

  cargoHash = "sha256-m29qIc/TsmropBMFeyEPIWwQgFh9PKqUexFRrbGFHSg=";

  meta = {
    description = "Cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    mainProgram = "cargo-chef";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kkharji ];
  };
})

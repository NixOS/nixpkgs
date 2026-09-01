{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "book-summary";
  version = "0.2.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-dxM6bqgHp4IaG03NriHvoT3al2u5Sz/I5ajlgzpjG1c=";
  };

  cargoHash = "sha256-8waVWCyjulMrXRc1nXZsiP4tMg70VZJ4wbgCQUgpX4A=";

  meta = {
    description = "Book auto-summary for gitbook and mdBook";
    mainProgram = "book-summary";
    homepage = "https://github.com/dvogt23/book-summary";
    license = lib.licenses.mit;
  };
})

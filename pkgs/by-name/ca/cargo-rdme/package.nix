{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-rdme";
  version = "1.5.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-d3WughXxh9cBzy33s3iB75paldZFokGGI1L9yTLGYoc=";
  };

  cargoHash = "sha256-26Poh5lUCYi+a+/E7pOYwilKX+eqRmbRNYRFdVfRSCw=";

  meta = {
    description = "Cargo command to create the README.md from your crate's documentation";
    mainProgram = "cargo-rdme";
    homepage = "https://github.com/orium/cargo-rdme";
    changelog = "https://github.com/orium/cargo-rdme/blob/v${finalAttrs.version}/release-notes.md";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [
      GoldsteinE
      chrjabs
    ];
  };
})

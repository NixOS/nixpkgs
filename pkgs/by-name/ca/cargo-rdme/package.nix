{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-rdme";
  version = "2.2.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Bj4NStDf3MOy2+nqqZU1FDDHE2/2WjeAuLjw/d+dplk=";
  };

  cargoHash = "sha256-ZxY9i7MB7SFE9CaMS0WY4GfpPlC6TUNQRYQuvP6PCbA=";

  meta = {
    description = "Cargo command to create the README.md from your crate's documentation";
    mainProgram = "cargo-rdme";
    homepage = "https://github.com/orium/cargo-rdme";
    changelog = "https://github.com/orium/cargo-rdme/blob/v${finalAttrs.version}/release-notes.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      GoldsteinE
      chrjabs
    ];
  };
})

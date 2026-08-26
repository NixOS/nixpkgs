{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-rdme";
  version = "2.2.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-uL6jZiQc/MZsn7H/cakZBMoH1phEQm6GR5v+WxnuaBw=";
  };

  cargoHash = "sha256-Q4D4ZvEKptLsnmn9/usPg5ZLse7yrXyZPTBsLpbhZWE=";

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

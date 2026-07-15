{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-rdme";
  version = "2.1.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-U5JD3VMuIagaMKxHoRRhbFyl7keuaJ0zNzD3Hjhxe/Y=";
  };

  cargoHash = "sha256-Es1K4MmThAS9whsfSQ8dUtjPjunCDCQc5FU8vsbeJPw=";

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

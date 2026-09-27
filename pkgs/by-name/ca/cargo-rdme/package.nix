{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-rdme";
  version = "2.2.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-jkbG/TUgi73tqjGy5kKPewdG5PKVyF9diZIu6pGBelk=";
  };

  cargoHash = "sha256-GCYhf127B1ke3mdHyqGuunYkoLR39ySl9L4Bv6JYmS8=";

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

{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-rdme";
  version = "2.0.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-mSwmVfwp1wFM3Xj+ASMpvZpgemcyicduk9l2WJYsYMw=";
  };

  cargoHash = "sha256-ZnWksGby1vEsA2BgvVy3Z2HNx8vZTY7J96GONAAOZKA=";

  meta = {
    description = "Cargo command to create the README.md from your crate's documentation";
    mainProgram = "cargo-rdme";
    homepage = "https://github.com/orium/cargo-rdme";
    changelog = "https://github.com/orium/cargo-rdme/blob/v${finalAttrs.version}/release-notes.md";
    license = with lib.licenses; mpl20;
    maintainers = with lib.maintainers; [
      GoldsteinE
      chrjabs
    ];
  };
})

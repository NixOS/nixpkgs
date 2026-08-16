{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-rdme";
  version = "2.2.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-f0MxJVWTcBNiURJFE60Xbv0/xcj51ZoZmJEzvIP79f4=";
  };

  cargoHash = "sha256-U2tw/tzFSktrKAIUk4fxyRCMVuw98uHXDkZ/YpC2aCA=";

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

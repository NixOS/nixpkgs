{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protonup-rs";
  version = "0.14.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-FHT//OHxMm7FXm/L+tZ+diGwbQ1i4EABKuFKO9SPm1M=";
  };

  cargoHash = "sha256-NOLYmJx0SvZ6azk34Ha/3512VSx+UHsepQQIYrHdLwM=";

  checkFlags = [
    # Requires internet access
    "--skip=downloads::tests"
  ];

  meta = {
    description = "Rust app to install and update GE-Proton for Steam, and Wine-GE for Lutris";
    homepage = "https://github.com/auyer/Protonup-rs";
    changelog = "https://github.com/auyer/Protonup-rs/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      joshprk
    ];
    mainProgram = "protonup-rs";
  };
})

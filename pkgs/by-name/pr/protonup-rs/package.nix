{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protonup-rs";
  version = "0.15.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-SqE3SKsiVnZUDa9ffazWi4RaIrIO9j7WanFM1HN6uW4=";
  };

  cargoHash = "sha256-l54zI1llVRjYjSKtgjAc2DXSnLS31CVhD3Q0TEKdNBA=";

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

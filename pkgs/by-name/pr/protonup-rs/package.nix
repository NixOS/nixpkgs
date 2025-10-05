{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protonup-rs";
  version = "0.9.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-zUsb+ZJmKUizBVwE4Uf/YnIukRn0AEQa7UeXdIIWYt8=";
  };

  cargoHash = "sha256-baa3VtGUnVFMwlPdKSa4jXecSlKogRHjKMfcGbqUFM0=";

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

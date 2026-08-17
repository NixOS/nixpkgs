{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protonup-rs";
  version = "0.12.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-u5SvZuuHPRBwOTUlVmtg9nY98INqKvSnHE83I8UsA0E=";
  };

  cargoHash = "sha256-LKZaTwJur4eBLFPtsMZEmaqTzFAxLJEytl61KMs2+Y4=";

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

{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protonup-rs";
  version = "0.12.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-tudrn2BeTB7+3DQmVxCMv+5vpIv3BwJ8sJqKwX+vHQU=";
  };

  cargoHash = "sha256-kgSMfEQHxOWBQSb1PMYU4HmYzQwrECiFAKKwq4d6vwc=";

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

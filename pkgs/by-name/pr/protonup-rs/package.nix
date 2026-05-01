{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protonup-rs";
  version = "0.10.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Ro5bYnmWs+Yjj6x5qkY2X1qBuQlvV7WIw4Oluvono54=";
  };

  cargoHash = "sha256-w6SBIsyxtbRtWRocskAG/UqBVRSvLoVS2fy9pTpWL4U=";

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

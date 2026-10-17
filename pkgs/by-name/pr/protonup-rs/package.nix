{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protonup-rs";
  version = "0.15.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "auyer";
    repo = "protonup-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b4ZYHoJoGayt2jTFMBaLP8UrVqKQDNXzM9/kLbkSgaA=";
  };

  cargoHash = "sha256-j4eWSQUIsH4E45NgMLIWA+IpyBLh3IJwLoXIr8wSEaY=";

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

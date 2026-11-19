{
  lib,
  rustPlatform,
  fetchFromGitHub,
  aws-lc,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protonup-rs";
  version = "0.16.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "auyer";
    repo = "protonup-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FqquDQjjff4cETJPEX4Io0KBk7eTbx0uJ1An+sRWmLk=";
  };

  cargoHash = "sha256-yF9/1Qk1iLVJ0/giecDW4J+0Sa8Vnz7xq/69uIKyLyg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    aws-lc
    zstd
  ];

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

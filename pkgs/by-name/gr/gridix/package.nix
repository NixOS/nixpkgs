{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  openssl,
  xdotool,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gridix";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "MCB-SMART-BOY";
    repo = "Gridix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y+2dwAm9LHTvCsHeZNY78vnOSC+m5b1xVnG+sj0V04c=";
  };

  cargoHash = "sha256-u+AAurOE6Ie9A81sdz9CI4Huw98sNUk2DsmIRmIz0DE=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    openssl
    xdotool
  ];

  preCheck = ''
    export RUST_TEST_THREADS=1
  '';

  meta = {
    description = "Fast, secure database management tool with Helix/Vim keybindings";
    longDescription = ''
      Gridix is a keyboard-driven database management tool supporting SQLite,
      PostgreSQL, and MySQL. Features include SSH tunneling, SSL/TLS encryption,
      AES-256-GCM encrypted password storage, 19 built-in themes, and Helix/Vim-style
      keybindings for efficient navigation and editing.
    '';
    homepage = "https://github.com/MCB-SMART-BOY/Gridix";
    changelog = "https://github.com/MCB-SMART-BOY/Gridix/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcbsmartboy ];
    mainProgram = "gridix";
    platforms = lib.platforms.linux;
  };
})

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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "MCB-SMART-BOY";
    repo = "Gridix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ANeJ9r1tJz0JJEa474ybGl5DRTjTp9C3/f0dPWAIDlE=";
  };

  cargoHash = "sha256-DLoB7GJrZr9JYq3uW7w0Oi5DhQYf27lKSJVY6zSzJfE=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    openssl
    xdotool
  ];

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mcb-smart-boy ];
    mainProgram = "gridix";
    platforms = lib.platforms.linux;
  };
})

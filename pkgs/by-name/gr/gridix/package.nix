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
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "MCB-SMART-BOY";
    repo = "Gridix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I0I6OgSS9iviM77ddHRdVAwRk6Mhl4qZyeAj/gnCvT4=";
  };

  cargoHash = "sha256-XgF0gRJWvFg4obaBNBXc117q7pf5hWDZ3T6T46gRB+Y=";

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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcbsmartboy ];
    mainProgram = "gridix";
    platforms = lib.platforms.linux;
  };
})

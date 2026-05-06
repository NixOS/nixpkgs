{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cairo,
  glib,
  pango,
  gdk-pixbuf,
  graphene,
  gtk4,
  gtk4-layer-shell,
  libadwaita,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cursor-clip";
  version = "0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "sirulex";
    repo = "cursor-clip";
    rev = "ad677e4b65340647b95b02a3cd1d955111506695";
    hash = "sha256-Hxg57v+gFjW7XyoGIGt7Pw4uXokBIWw88/0a00PzckI=";
  };

  cargoHash = "sha256-5p5tt3dnluRkY0/zIXv6p8mi/hd42yV2E8qsVy+lqz0=";

  nativeBuildInputs = [
    pkg-config
    glib
  ];

  buildInputs = [
    cairo
    pango
    gdk-pixbuf
    graphene
    gtk4
    gtk4-layer-shell
    libadwaita
  ];

  meta = {
    description = "Cursor Clip - GTK4 Clipboard Manager with dynamic positioning. Features a Windows 11–style clipboard history, adapted to native GNOME design";
    homepage = "https://github.com/sirulex/cursor-clip";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "cursor-clip";
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland-scanner,
  wayland,
  wayland-protocols,
  libxkbcommon,
  cairo,
  gdk-pixbuf,
  pam,
  wrapGAppsNoGuiHook,
  librsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swaylock";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaylock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l3fu04cw2Jin2F6UcDK0kWRJLKuwXpxuImUjoLk32Fc=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
    wrapGAppsNoGuiHook
    gdk-pixbuf
  ];
  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    cairo
    gdk-pixbuf
    pam
    librsvg
  ];

  mesonFlags = [
    "-Dpam=enabled"
    "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled"
  ];

  meta = {
    description = "Screen locker for Wayland";
    longDescription = ''
      swaylock is a screen locking utility for Wayland compositors.
      Important note: If you don't use the Sway module (programs.sway.enable)
      you need to set "security.pam.services.swaylock = {};" manually.
    '';
    inherit (finalAttrs.src.meta) homepage;
    mainProgram = "swaylock";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wineee ];
  };
})

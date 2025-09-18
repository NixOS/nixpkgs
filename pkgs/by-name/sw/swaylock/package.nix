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

stdenv.mkDerivation rec {
  pname = "swaylock";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaylock";
    tag = "v${version}";
    hash = "sha256-5JAA8mCY3vOsauvRK2zquBrzA2ROakEfahzp4a6j/Ac=";
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

  meta = with lib; {
    description = "Screen locker for Wayland";
    longDescription = ''
      swaylock is a screen locking utility for Wayland compositors.
      Important note: If you don't use the Sway module (programs.sway.enable)
      you need to set "security.pam.services.swaylock = {};" manually.
    '';
    inherit (src.meta) homepage;
    mainProgram = "swaylock";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wineee ];
  };
}

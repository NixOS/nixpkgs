{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland,
  wayland-protocols,
  cairo,
  gdk-pixbuf,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "swaybg";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaybg";
    rev = "v${version}";
    hash = "sha256-IJcPSBJErf8Dy9YhYAc9eg/llgaaLZCQSB0Brof+kpg=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    wayland
    wayland-protocols
    cairo
    gdk-pixbuf
  ];

  mesonFlags = [
    "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled"
  ];

  meta = with lib; {
    description = "Wallpaper tool for Wayland compositors";
    inherit (src.meta) homepage;
    longDescription = ''
      A wallpaper utility for Wayland compositors, that is compatible with any
      Wayland compositor which implements the following Wayland protocols:
      wlr-layer-shell, xdg-output, and xdg-shell.
    '';
    license = licenses.mit;
    mainProgram = "swaybg";
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
  };
}

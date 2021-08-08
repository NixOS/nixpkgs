{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc
, wayland, wayland-protocols, cairo, gdk-pixbuf
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "swaybg";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaybg";
    rev = "v${version}";
    sha256 = "17508q9wsw6c1lsxlcbxj74z2naqhwi5c7lkbq24m4lk8qmy0576";
  };

  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland wayland-protocols cairo gdk-pixbuf ];

  mesonFlags = [
    "-Dgdk-pixbuf=enabled" "-Dman-pages=enabled"
  ];

  meta = with lib; {
    description = "Wallpaper tool for Wayland compositors";
    longDescription = ''
      A wallpaper utility for Wayland compositors, that is compatible with any
      Wayland compositor which implements the following Wayland protocols:
      wlr-layer-shell, xdg-output, and xdg-shell.
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}

{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc
, wayland, wayland-protocols, cairo, gdk-pixbuf
}:

stdenv.mkDerivation rec {
  pname = "swaybg";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaybg";
    rev = version;
    sha256 = "1lmqz5bmig90gq2m7lwf02d2g7z4hzf8fhqz78c8vk92c6p4xwbc";
  };

  nativeBuildInputs = [ meson ninja pkg-config scdoc ];
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

{ lib, stdenv, fetchurl, pkg-config, intltool, autoconf, automake, libtool, gettext, emerald }:

stdenv.mkDerivation rec {
  pname = "emerald-themes";
  version = "0.8.18";

  src = fetchurl {
    url = "https://gitlab.com/compiz/emerald-themes/-/archive/v\0.8.18/emerald-themes-v\0.8.18.tar.gz";
    hash = "sha256-d0gkBToiIW1v0dXyXuj7O4xWGI9Ztw0vGZz+FYDo2XM=";
  };

  nativeBuildInputs = [ pkg-config intltool autoconf automake libtool gettext ];

  buildInputs = [ emerald ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  meta = {
    description = "Emerald Window Decorator Themes";
    homepage = "https://gitlab.com/compiz/emerald-themes";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}

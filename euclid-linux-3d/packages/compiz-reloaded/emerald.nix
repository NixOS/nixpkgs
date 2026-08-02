{ lib, stdenv, fetchurl, pkg-config, intltool, autoconf, automake, libtool, gettext, xorg, cairo, libwnck, pango, glib, gtk2, compiz-core }:

stdenv.mkDerivation rec {
  pname = "emerald";
  version = "0.8.18";

  src = fetchurl {
    url = "https://gitlab.com/compiz/emerald/-/archive/v\0.8.18/emerald-v\0.8.18.tar.gz";
    hash = "sha256-k/KNATwIcKTWdouDwgmwxGjLMMYjCA13PM8tdIpWN9U=";
  };

  nativeBuildInputs = [ pkg-config intltool autoconf automake libtool gettext ];

  buildInputs = [
    compiz-core
    xorg.libX11 xorg.libXext xorg.libXrender xorg.libXcomposite xorg.libXdamage
    cairo libwnck pango glib gtk2
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  meta = {
    description = "Emerald Window Decorator";
    homepage = "https://gitlab.com/compiz/emerald";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}

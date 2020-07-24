{ stdenv, fetchurl, pkgconfig, glib, gtk2, menu-cache }:

stdenv.mkDerivation rec {
  pname = "openbox-menu";
  version = "0.8.0";

  src = fetchurl {
    url = "https://bitbucket.org/fabriceT/openbox-menu/downloads/${pname}-${version}.tar.bz2";
    sha256 = "1hi4b6mq97y6ajq4hhsikbkk23aha7ikaahm92djw48mgj2f1w8l";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gtk2 menu-cache ];

  patches = [ ./with-svg.patch ];

  installPhase = "make install prefix=$out";

  meta = {
    homepage = "http://fabrice.thiroux.free.fr/openbox-menu_en.html";
    description = "Dynamic XDG menu generator for Openbox";
    longDescription = ''
      Openbox-menu is a pipemenu for Openbox window manager. It provides a
      dynamic menu listing installed applications. Most of the work is done by
      the LXDE library menu-cache.
    '';
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms   = stdenv.lib.platforms.unix;
  };
}

{ stdenv, fetchurl, pkgconfig, glib, gtk, menu-cache }:

stdenv.mkDerivation rec {
  name = "openbox-menu-0.5.1";

  src = fetchurl {
    url = "https://bitbucket.org/fabriceT/openbox-menu/downloads/${name}.tar.bz2";
    sha256 = "11v3nlhqcnks5vms1a7rrvwvj8swc9axgjkp7z0r97lijsg6d3rj";
  };

  buildInputs = [ pkgconfig glib gtk menu-cache ];

  patches = [ ./with-svg.patch ];

  installPhase = "make install prefix=$out";

  meta = {
    description = "Dynamic XDG menu generator for Openbox";
    homepage = "http://mimasgpc.free.fr/openbox-menu.html";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms   = stdenv.lib.platforms.unix;
  };
}

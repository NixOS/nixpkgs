{ stdenv, fetchurl, pkgconfig, glib, pango, libxml2, libXau }:

stdenv.mkDerivation rec {
  name = "openbox-3-4-11-2";

  buildInputs = [ pkgconfig glib pango libxml2 libXau ];

  src = fetchurl {
    url = http://openbox.org/dist/openbox/openbox-3.4.11.2.tar.gz;
    sha256 = "2e7579389c30e6bb08cc721a2c1af512e049fec2670e71715aa1c4e129ec349d";
  };

  meta = {
    description = "X window manager for non-desktop embedded systems";
    homepage = http://openbox.org/;
    license = "GPLv2+";
  };
}

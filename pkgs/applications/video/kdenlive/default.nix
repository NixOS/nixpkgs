{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon, mlt, gettext,
shared_mime_info, soprano}:

stdenv.mkDerivation {
  name = "kdenlive-0.7.8";
  src = fetchurl {
    url = mirror://sourceforge/kdenlive/kdenlive-0.7.8.tar.gz;
    sha256 = "10bwmhh3kzdbq1nzq8s5ln7ydrzg41d1rihj5kdmf5hb91az8mvx";
  };

  prePatch = ''
    # For Qt47 compatibility.
    sed -i 's@class QImage@#include <QImage>@' src/colorcorrection/vectorscopegenerator.h
  '';

  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon mlt gettext
    shared_mime_info soprano ];

  meta = {
    description = "Free and open source video editor";
    license = "GPLv2+";
    homepage = http://www.kdenlive.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

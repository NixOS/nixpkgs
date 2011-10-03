{stdenv, fetchurl, perl, arts, qt, kdelibs,
 libX11, libXt, libXext, libXrender, libXft,
 zlib, libpng, libjpeg, freetype, expat }:

stdenv.mkDerivation {
  name = "kile-2.0.3";

  src = fetchurl {
    url = mirror://sourceforge/kile/kile-2.0.3.tar.bz2;
    md5 = "f0296547d3e916dd385e0b8913918852";
  };

  buildInputs = [ perl arts qt kdelibs libX11 libXt libXext libXrender libXft
                  zlib libpng libjpeg freetype expat ];

  meta = {
    description = "An integrated LaTeX editor for KDE";
    homepage = http://kile.sourceforge.net;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.linux;
  };
}

{stdenv, fetchurl, perl, arts, qt, kdelibs, libX11, libXt, libXext, libXrender, libXft, zlib, libpng, libjpeg, freetype, expat }:

stdenv.mkDerivation {
  name = "kile-2.0";

  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/kile/kile-2.0.tar.bz2;
    sha256 = "14a7e4605a3ee486b9a7c11e9bd3236bdbd34955d5522eac5da1e511dea6c7e2";
  };

  buildInputs = [ perl arts qt kdelibs libX11 libXt libXext libXrender libXft zlib libpng libjpeg freetype expat ];
}

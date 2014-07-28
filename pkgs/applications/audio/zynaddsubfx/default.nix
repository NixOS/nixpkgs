{ stdenv, fetchurl, alsaLib, cmake, jack2, fftw, fltk13, minixml
, pkgconfig, zlib
}:

stdenv.mkDerivation  rec {
  name = "zynaddsubfx-${version}";
  version = "2.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/zynaddsubfx/ZynAddSubFX-${version}.tar.bz2";
    sha256 = "0kgmwyh4rhyqdfrdzhbzjjk2hzggkp9c4aac6sy3xv6cc1b5jjxq";
  };

  buildInputs = [ alsaLib jack2 fftw fltk13 minixml zlib ];
  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "High quality software synthesizer";
    homepage = http://zynaddsubfx.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}

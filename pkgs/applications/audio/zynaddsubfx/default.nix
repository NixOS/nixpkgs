{ stdenv, fetchurl, alsaLib, cmake, libjack2, fftw, fltk13, libjpeg
, minixml, pkgconfig, zlib, liblo
}:

stdenv.mkDerivation  rec {
  name = "zynaddsubfx-${version}";
  version = "2.5.4";

  src = fetchurl {
    url = "mirror://sourceforge/zynaddsubfx/zynaddsubfx-${version}.tar.bz2";
    sha256 = "16llaa2wg2gbgjhwp3632b2vx9jvanj4csv7d41k233ms6d1sjq1";
  };

  buildInputs = [ alsaLib libjack2 fftw fltk13 libjpeg minixml zlib liblo ];
  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "High quality software synthesizer";
    homepage = http://zynaddsubfx.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.nico202 ];
  };
}

{ stdenv, fetchurl, alsaLib, cairo, cmake, libjack2, fftw, fltk13, lash,  libjpeg
, libXpm, minixml, ntk, pkgconfig, zlib, liblo
}:

stdenv.mkDerivation  rec {
  name = "zynaddsubfx-${version}";
  version = "3.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/zynaddsubfx/zynaddsubfx-${version}.tar.bz2";
    sha256 = "09mr23lqc51r7gskry5b7hk84pghdpgn1s4vnrzvx7xpa21gvplm";
  };

  buildInputs = [ alsaLib cairo libjack2 fftw fltk13 lash libjpeg libXpm minixml ntk zlib liblo ];
  nativeBuildInputs = [ cmake pkgconfig ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "High quality software synthesizer";
    homepage = http://zynaddsubfx.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.nico202 ];
  };
}

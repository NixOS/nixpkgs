{ stdenv, fetchurl, alsaLib, cairo, cmake, libjack2, fftw, fltk13, lash,  libjpeg
, libXpm, minixml, ntk, pkgconfig, zlib, liblo
}:

stdenv.mkDerivation  rec {
  name = "zynaddsubfx-${version}";
  version = "3.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/zynaddsubfx/zynaddsubfx-${version}.tar.bz2";
    sha256 = "1qijvlbv41lnqaqbp6gh1i42xzf1syviyxz8wr39xbz55cw7y0d8";
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

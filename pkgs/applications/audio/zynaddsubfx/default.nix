{ stdenv, fetchurl, alsaLib, cairo, cmake, libjack2, fftw, fltk13, lash,  libjpeg
, libXpm, minixml, ntk, pkgconfig, zlib, liblo
}:

stdenv.mkDerivation  rec {
  name = "zynaddsubfx-${version}";
  version = "3.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/zynaddsubfx/zynaddsubfx-${version}.tar.bz2";
    sha256 = "1hfpiqdm337gl4ynkmmp2qss2m5z8mzqzjrbiyg6w1v4js7l9phi";
  };

  buildInputs = [ alsaLib cairo libjack2 fftw fltk13 lash libjpeg libXpm minixml ntk zlib liblo ];
  nativeBuildInputs = [ cmake pkgconfig ];

  patchPhase = ''
    substituteInPlace src/Misc/Config.cpp --replace /usr $out
  '';

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "High quality software synthesizer";
    homepage = http://zynaddsubfx.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.nico202 ];
  };
}

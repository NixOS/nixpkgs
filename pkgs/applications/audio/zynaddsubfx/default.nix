{ stdenv, fetchurl, alsaLib, cmake, libjack2, fftw, fltk13, libjpeg
, minixml, pkgconfig, zlib, liblo
}:

stdenv.mkDerivation  rec {
  name = "zynaddsubfx-${version}";
  version = "2.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/zynaddsubfx/zynaddsubfx-${version}.tar.gz";
    sha256 = "11yrady7xwfrzszkk2fvq81ymv99mq474h60qnirk27khdygk24m";
  };

  buildInputs = [ alsaLib libjack2 fftw fltk13 libjpeg minixml zlib liblo ];
  nativeBuildInputs = [ cmake pkgconfig ];

  postPatch = ''
    substituteInPlace ./src/DSP/FFTwrapper.h --replace "isnan(" "std::isnan(" --replace "isinf(" "std::isinf("
  '';

  meta = with stdenv.lib; {
    description = "High quality software synthesizer";
    homepage = http://zynaddsubfx.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.palo ];
  };
}

{ stdenv, fetchurl, alsaLib, boost, cmake, fftwSinglePrec, fltk
, jackaudio, libsndfile, mesa, minixml, pkgconfig, zlib }:

assert stdenv ? glibc;

stdenv.mkDerivation  rec {
  name = "yoshimi-${version}";
  version = "0.060.12";

  src = fetchurl {
    url = "mirror://sourceforge/yoshimi/${name}.tar.bz2";
    sha256 = "14javywkw6af9z9c7jr06rzdgzncyaz2ab6f0v0k6bgdndlcgslc";
  };

  buildInputs = [ alsaLib boost fftwSinglePrec fltk jackaudio libsndfile mesa
    minixml zlib ];
  nativeBuildInputs = [ cmake pkgconfig ];

  preConfigure = "cd src";

  cmakeFlags = [ "-DFLTK_MATH_LIBRARY=${stdenv.glibc}/lib/libm.so" ];

  meta = with stdenv.lib; {
    description = "high quality software synthesizer based on ZynAddSubFX";
    longDescription = ''
      Yoshimi delivers the same synthesizer capabilities as
      ZynAddSubFX along with very good Jack and Alsa midi/audio
      functionality on Linux
    '';
    homepage = http://yoshimi.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}

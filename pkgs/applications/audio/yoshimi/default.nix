{ stdenv, fetchurl, alsaLib, boost, cmake, fftwSinglePrec, fltk
, jackaudio, libsndfile, mesa, minixml, pkgconfig, zlib }:

assert stdenv ? glibc;

stdenv.mkDerivation  rec {
  name = "yoshimi-${version}";
  version = "0.060.10";

  src = fetchurl {
    url = "mirror://sourceforge/yoshimi/${name}.tar.bz2";
    sha256 = "0y67w7y515hx2bi5gfjgsw1hdah1bdrrvcfmqyjsvn7jbd0q47v1";
  };

  buildInputs = [ alsaLib boost fftwSinglePrec fltk jackaudio libsndfile mesa
    minixml zlib ];
  buildNativeInputs = [ cmake pkgconfig ];

  preConfigure = "cd src";

  patches = [
    (fetchurl {
      url = http://patch-tracker.debian.org/patch/series/dl/yoshimi/0.060.10-3/02-fluid_1.3.patch;
      sha256 = "1sywirbaaw4zhn5ypga27j02qvrvqjwv3lw8kvzyj575q4c4qnri";
    })
  ];

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

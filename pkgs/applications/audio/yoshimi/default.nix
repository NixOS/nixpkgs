{ stdenv, fetchurl, alsaLib, boost, cmakeCurses, fftwSinglePrec, fltk
, jackaudio, libsndfile, mesa, minixml, pkgconfig, zlib }:

assert stdenv ? glibc;

stdenv.mkDerivation  rec {
  name = "yoshimi-${version}";
  version = "0.060.10";

  src = fetchurl {
    url = "mirror://sourceforge/yoshimi/${name}.tar.bz2";
    sha256 = "0y67w7y515hx2bi5gfjgsw1hdah1bdrrvcfmqyjsvn7jbd0q47v1";
  };

  buildInputs = [ alsaLib boost cmakeCurses fftwSinglePrec fltk
    jackaudio libsndfile mesa minixml pkgconfig zlib ];

  preConfigure = ''
    cd src
  '';

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

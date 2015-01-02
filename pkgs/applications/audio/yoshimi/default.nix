{ stdenv, fetchurl, alsaLib, boost, cairo, cmake, fftwSinglePrec, fltk
, jack2, libsndfile, lv2, mesa, minixml, pkgconfig, zlib, xorg
}:

assert stdenv ? glibc;

stdenv.mkDerivation  rec {
  name = "yoshimi-${version}";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/yoshimi/${name}.tar.bz2";
    sha256 = "1nj71xmjgr0pdqwv6h9kigdvljh8hggy6az9rnd7f64r13nmrphl";
  };

  buildInputs = [
    alsaLib boost cairo fftwSinglePrec fltk jack2 libsndfile lv2 mesa
    minixml zlib xorg.libpthreadstubs
  ];

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

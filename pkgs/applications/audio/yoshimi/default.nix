{ stdenv, fetchurl, alsaLib, boost, cairo, cmake, fftwSinglePrec, fltk
, jack2, libsndfile, lv2, mesa, minixml, pkgconfig, zlib, xorg
}:

assert stdenv ? glibc;

stdenv.mkDerivation  rec {
  name = "yoshimi-${version}";
  version = "1.3.3";

  src = fetchurl {
    url = "mirror://sourceforge/yoshimi/${name}.tar.bz2";
    sha256 = "0f37xjkay3800fbx0iwjca005b1hrjbhszrzn0xg662vf8mj44nv";
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

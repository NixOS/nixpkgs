{ stdenv, fetchurl, alsaLib, boost, cairo, cmake, fftwSinglePrec, fltk, pcre
, libjack2, libsndfile, libXdmcp, readline, lv2, libGLU, libGL, minixml, pkgconfig, zlib, xorg
}:

assert stdenv ? glibc;

stdenv.mkDerivation  rec {
  pname = "yoshimi";
  version = "1.6.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/yoshimi/${pname}-${version}.tar.bz2";
    sha256 = "1z2mnmm299ng6jcwa61dzr1ilwa5fjgsggxl2wa5smji6b4npmx7";
  };

  buildInputs = [
    alsaLib boost cairo fftwSinglePrec fltk libjack2 libsndfile libXdmcp readline lv2 libGLU libGL
    minixml zlib xorg.libpthreadstubs pcre
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  patchPhase = ''
    substituteInPlace src/Misc/Config.cpp --replace /usr $out
    substituteInPlace src/Misc/Bank.cpp --replace /usr $out
  '';

  preConfigure = "cd src";

  cmakeFlags = [ "-DFLTK_MATH_LIBRARY=${stdenv.glibc.out}/lib/libm.so" ];

  meta = with stdenv.lib; {
    description = "High quality software synthesizer based on ZynAddSubFX";
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

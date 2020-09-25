{ stdenv, fetchFromGitHub , alsaLib, boost, cairo, cmake, fftwSinglePrec, fltk, pcre
, libjack2, libsndfile, libXdmcp, readline, lv2, libGLU, libGL, minixml, pkgconfig, zlib, xorg
}:

assert stdenv ? glibc;

stdenv.mkDerivation  rec {
  pname = "yoshimi";
  # Fix build with lv2 1.18: https://github.com/Yoshimi/yoshimi/pull/102/commits/86996cbb235f0fe138ae814a6758c2c8ba1c2a38
  version = "unstable-2020-05-10";

  src = fetchFromGitHub {
    owner = "Yoshimi";
    repo = pname;
    rev = "86996cbb235f0fe138ae814a6758c2c8ba1c2a38";
    sha256 = "0bgcc5fbgwpdjircq00wlii30pakf45yzligpbnf02a554hh4j01";
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
    homepage = "http://yoshimi.sourceforge.net";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}

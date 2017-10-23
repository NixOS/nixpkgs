{ stdenv, fetchurl, alsaLib, boost, cairo, cmake, fftwSinglePrec, fltk
, libjack2, libsndfile, libXdmcp, readline, lv2, mesa, minixml, pkgconfig, zlib, xorg
}:

assert stdenv ? glibc;

stdenv.mkDerivation  rec {
  name = "yoshimi-${version}";
  version = "1.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/yoshimi/${name}.tar.bz2";
    sha256 = "0sns35pyw2f74xrv1fxiyf9g9415kvh2rrbdjd60hsiv584nlari";
  };

  buildInputs = [
    alsaLib boost cairo fftwSinglePrec fltk libjack2 libsndfile libXdmcp readline lv2 mesa
    minixml zlib xorg.libpthreadstubs
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  patchPhase = ''
    sed -i -e 's,/usr/share,'$out/share,g src/Misc/Config.cpp src/Misc/Bank.cpp
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

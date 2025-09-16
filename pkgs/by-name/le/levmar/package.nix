{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "levmar";
  version = "2.6";

  src = fetchurl {
    url = "https://www.ics.forth.gr/~lourakis/levmar/${pname}-${version}.tgz";
    sha256 = "1mxsjip9x782z6qa6k5781wjwpvj5aczrn782m9yspa7lhgfzx1v";
  };

  patchPhase = ''
    substituteInPlace levmar.h --replace "define HAVE_LAPACK" "undef HAVE_LAPACK"
    sed -i 's/LAPACKLIBS=.*/LAPACKLIBS=/' Makefile
    substituteInPlace Makefile --replace "gcc" "${stdenv.cc.targetPrefix}cc"
  ''
  # ref. https://github.com/alemuntoni/levmar/commit/7524578ad6703f8f6516e4d2885b8524e1bb26fa
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace compiler.h --replace-fail \
      "#define LM_FINITE finite // ICC, GCC" \
      "#define LM_FINITE isfinite // ICC, GCC"
  '';

  installPhase = ''
    mkdir -p $out/include $out/lib
    cp lm.h $out/include
    cp liblevmar.a $out/lib
  '';

  meta = {
    description = "ANSI C implementations of Levenberg-Marquardt, usable also from C++";
    homepage = "https://www.ics.forth.gr/~lourakis/levmar/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}

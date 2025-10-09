{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "levmar";
  version = "2.6";

  src = fetchurl {
    url = "https://www.ics.forth.gr/~lourakis/levmar/levmar-${finalAttrs.version}.tgz";
    hash = "sha256-O/TvHqRHXe1TFejY/Jkqcl8ueUCnTKOw+QKdnm6Uutc=";
  };

  postPatch = ''
    substituteInPlace levmar.h --replace-fail "define HAVE_LAPACK" "undef HAVE_LAPACK"
    sed -i 's/LAPACKLIBS=.*/LAPACKLIBS=/' Makefile
    substituteInPlace Makefile --replace-fail "gcc" "${stdenv.cc.targetPrefix}cc"
  ''
  + lib.optionalString stdenv.cc.isClang ''
    substituteInPlace compiler.h \
      --replace-fail "#define LM_FINITE finite // ICC, GCC" \
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
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})

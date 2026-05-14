{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libantlr3c";
  version = "3.4";
  src = fetchurl {
    url = "https://www.antlr3.org/download/C/libantlr3c-${finalAttrs.version}.tar.gz";
    sha256 = "0lpbnb4dq4azmsvlhp6khq1gy42kyqyjv8gww74g5lm2y6blm4fa";
  };

  configureFlags =
    lib.optional stdenv.hostPlatform.is64bit "--enable-64bit"
    # libantlr3c wrongly emits the abi flags -m64 and -m32 which imply x86 archs
    # https://github.com/antlr/antlr3/issues/205
    ++ lib.optional (!stdenv.hostPlatform.isx86) "--disable-abiflags";

  meta = {
    description = "C runtime libraries of ANTLR v3";
    homepage = "https://www.antlr3.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ vbgl ];
  };
})

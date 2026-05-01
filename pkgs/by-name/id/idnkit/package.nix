{
  lib,
  stdenv,
  fetchurl,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "idnkit";
  version = "2.3";

  src = fetchurl {
    url = "https://jprs.co.jp/idn/idnkit-${finalAttrs.version}.tar.bz2";
    hash = "sha256-JtBxF2UAQqtGk/DgCWAnXVihvnc+bRPFA7o4RxDz6X4=";
  };

  buildInputs = [ libiconv ];

  # Ignore errors since gcc-14.
  #   localconverter.c:602:21/607:26/633:26: error: passing argument 2 of 'iconv' from incompatible pointer type
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  meta = {
    homepage = "https://jprs.co.jp/idn/index-e.html";
    description = "Provides functionalities about i18n domain name processing";
    license = {
      fullName = "Open Source Code License version 1.1";
      url = "https://jprs.co.jp/idn/idnkit2-OSCL.txt";
    };
    platforms = lib.platforms.linux;
  };
})

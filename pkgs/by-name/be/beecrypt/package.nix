{
  lib,
  stdenv,
  fetchurl,
  m4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "beecrypt";
  version = "4.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/beecrypt/beecrypt-${finalAttrs.version}.tar.gz";
    hash = "sha256-KG8fVggNGmsdAkADpfohWPT/gsrgxoKdPEdqS1iYxV0=";
  };

  postPatch = ''
    sed -i '33i #include "beecrypt/endianness.h"' blockmode.c
  '';

  buildInputs = [ m4 ];

  configureFlags = [
    "--disable-optimized"
    "--enable-static"
  ];

  meta = {
    description = "Strong and fast cryptography toolkit library";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl2;
    maintainers = [ ];
  };
})

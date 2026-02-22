{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libroxml";
  version = "2.3.0";

  src = fetchurl {
    url = "http://download.libroxml.net/pool/v2.x/libroxml-${finalAttrs.version}.tar.gz";
    sha256 = "0y0vc9n4rfbimjp28nx4kdfzz08j5xymh5xjy84l9fhfac5z5a0x";
  };

  meta = {
    description = "This library is minimum, easy-to-use, C implementation for xml file parsing";
    homepage = "https://www.libroxml.net/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ mpickering ];
    mainProgram = "roxml";
    platforms = lib.platforms.unix;
  };
})

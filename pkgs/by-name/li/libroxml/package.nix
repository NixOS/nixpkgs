{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libroxml";
  version = "2.3.0";

  src = fetchurl {
    url = "http://download.libroxml.net/pool/v2.x/libroxml-${version}.tar.gz";
    sha256 = "0y0vc9n4rfbimjp28nx4kdfzz08j5xymh5xjy84l9fhfac5z5a0x";
  };

<<<<<<< HEAD
  meta = {
    description = "This library is minimum, easy-to-use, C implementation for xml file parsing";
    homepage = "https://www.libroxml.net/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ mpickering ];
    mainProgram = "roxml";
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "This library is minimum, easy-to-use, C implementation for xml file parsing";
    homepage = "https://www.libroxml.net/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ mpickering ];
    mainProgram = "roxml";
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

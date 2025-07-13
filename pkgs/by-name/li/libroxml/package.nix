{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libroxml";
  version = "2.3.0";

  src = fetchurl {
    url = "https://download.libroxml.net/pool/v2.x/libroxml-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  meta = with lib; {
    description = "This library is minimum, easy-to-use, C implementation for xml file parsing";
    homepage = "https://www.libroxml.net/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ mpickering ];
    mainProgram = "roxml";
    platforms = platforms.unix;
  };
}

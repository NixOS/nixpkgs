{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "enet";
  version = "1.3.18";

  src = fetchurl {
    url = "http://enet.bespin.org/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-KooMU2DWi7T80R8uTEfGmXbo0shbEJ3X1gsRgaT4XTY=";
  };

  meta = with lib; {
    homepage = "http://enet.bespin.org/";
    description = "Simple and robust network communication layer on top of UDP";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}

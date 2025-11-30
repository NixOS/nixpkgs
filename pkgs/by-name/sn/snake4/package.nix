{
  lib,
  stdenv,
  fetchurl,
  shhmsg,
  shhopt,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "snake4";
  version = "1.0.14";

  src = fetchurl {
    url = "https://shh.thathost.com/pub-unix/files/snake4-${version}.tar.gz";
    sha256 = "14cng9l857np42zixp440mbc8y5675frb6lhsds53j1cws9cncw9";
  };

  buildInputs = with xorg; [
    shhmsg
    shhopt
    libX11
    libXt
    libXpm
    libXaw
    libXext
  ];

  preInstall = ''
    substituteInPlace Makefile \
      --replace "-o \$(OWNER) -g \$(GROUP)" "" \
      --replace "4755" "755"
  '';

  installFlags = [
    "INSTLIBDIR=$(out)/lib"
    "INSTBINDIR=$(out)/bin"
    "INSTMANDIR=$(out)/man"
  ];

  meta = with lib; {
    description = "Game starring a fruit-eating snake";
    homepage = "https://shh.thathost.com/pub-unix/html/snake4.html";
    license = licenses.artistic1;
    platforms = platforms.linux;
  };
}

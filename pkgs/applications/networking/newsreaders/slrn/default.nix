{ lib, stdenv, fetchurl
, slang, ncurses, openssl }:

stdenv.mkDerivation rec {
  pname = "slrn";
  version = "1.0.3a";

  src = fetchurl {
    url = "http://www.jedsoft.org/releases/slrn/slrn-${version}.tar.bz2";
    sha256 = "1b1d9iikr60w0vq86y9a0l4gjl0jxhdznlrdp3r405i097as9a1v";
  };

  preConfigure = ''
    sed -i -e "s|-ltermcap|-lncurses|" configure
    sed -i autoconf/Makefile.in src/Makefile.in \
      -e "s|/bin/cp|cp|"  \
      -e "s|/bin/rm|rm|"
  '';

  configureFlags = [
    "--with-slang=${slang.dev}"
    "--with-ssl=${openssl.dev}"
    "--with-slrnpull"
  ];

  buildInputs = [ slang ncurses openssl ];

  meta = with lib; {
    description = "The slrn (S-Lang read news) newsreader";
    homepage = "https://slrn.sourceforge.net/index.html";
    license = licenses.gpl2;
    platforms = with platforms; linux;
  };
}

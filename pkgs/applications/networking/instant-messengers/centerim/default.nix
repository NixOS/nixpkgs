{stdenv, fetchurl, openssl, curl, ncurses, gpgme, libjpeg }:

stdenv.mkDerivation rec {
  name = "centerim-4.22.10";

  src = fetchurl {
    url = "http://centerim.org/download/releases/${name}.tar.gz";
    sha256 = "0viz86jflp684vfginhl6aaw4gh2qvalc25anlwljjl3kkmibklk";
  };

  buildInputs = [ openssl curl ncurses gpgme libjpeg ];

  configureFlags = [ "--with-openssl=${openssl}" ];

  meta = {
    homepage = http://www.centerim.org/;
    description = "Fork of CenterICQ, a curses instant messaging program";
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
  };
}

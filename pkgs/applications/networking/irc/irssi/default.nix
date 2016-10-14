{ stdenv, fetchurl, pkgconfig, ncurses, glib, openssl, perl, libintlOrEmpty }:

stdenv.mkDerivation rec {

  version = "0.8.20";
  name = "irssi-${version}";

  src = fetchurl {
    urls = [ "https://github.com/irssi/irssi/releases/download/${version}/${name}.tar.gz" ];
    sha256 = "0riz2wsdcs5hx5rwynm99fi01973lfrss21y8qy30dw2m9v0zqpm";
  };

  buildInputs = [ pkgconfig ncurses glib openssl perl libintlOrEmpty ];

  NIX_LDFLAGS = ncurses.ldflags;

  configureFlags = "--with-proxy --with-ncurses --enable-ssl --with-perl=yes";

  meta = {
    homepage    = http://irssi.org;
    description = "A terminal based IRC client";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
  };
}

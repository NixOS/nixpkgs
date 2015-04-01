{ stdenv, fetchurl, pkgconfig, ncurses, glib, openssl, perl, libintlOrEmpty }:

stdenv.mkDerivation rec {
  name = "irssi-0.8.17";
  
  src = fetchurl {
    url = "http://irssi.org/files/${name}.tar.bz2";
    sha256 = "01v82q2pfiimx6lh271kdvgp8hl4pahc3srg04fqzxgdsb5015iw";
  };
  
  buildInputs = [ pkgconfig ncurses glib openssl perl libintlOrEmpty ];
  
  NIX_LDFLAGS = "-lncurses";
  
  configureFlags = "--with-proxy --with-ncurses --enable-ssl --with-perl=yes";

  meta = {
    homepage    = http://irssi.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
  };
}

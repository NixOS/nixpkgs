{ stdenv, fetchurl, pkgconfig, ncurses, glib, openssl, perl, libintlOrEmpty }:

stdenv.mkDerivation rec {
  name = "irssi-0.8.16";
  
  src = fetchurl {
    url = "http://irssi.org/files/${name}.tar.bz2";
    sha256 = "15wzs4h754jzs1l4z7qzsyjllk9wdx3qfb6gymdiykvmlb9gwyiz";
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

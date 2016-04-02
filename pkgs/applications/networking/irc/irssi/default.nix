{ stdenv, fetchurl, pkgconfig, ncurses, glib, openssl, perl, libintlOrEmpty }:

stdenv.mkDerivation rec {

  version = "0.8.19";
  name = "irssi-${version}";

  src = fetchurl {
    urls = [ "https://github.com/irssi/irssi/releases/download/${version}/${name}.tar.gz" ];
    sha256 = "0ny8dry1b8siyc5glaxcwzng0d2mxnwxk74v64f8xplqhrvlnkzy";
  };

  buildInputs = [ pkgconfig ncurses glib openssl perl libintlOrEmpty ];

  NIX_LDFLAGS = ncurses.ldflags;

  configureFlags = "--with-proxy --with-ncurses --enable-ssl --with-perl=yes";

  meta = {
    homepage    = http://irssi.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
  };
}

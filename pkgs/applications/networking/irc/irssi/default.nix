{stdenv, fetchurl, pkgconfig, ncurses, glib, openssl}:

stdenv.mkDerivation {
  name = "irssi-0.8.12";
  src = fetchurl {
    url = http://irssi.org/files/irssi-0.8.12.tar.bz2;
    sha256 = "1w7zkfs6j7xdcbqh8x0vf9rk2ps9d6rcgr8fapfjpk09nm5n6ba6";
  };
  buildInputs = [pkgconfig ncurses glib openssl];
  NIX_LDFLAGS = "-lncurses";
  configureFlags = "--with-proxy --with-ncurses --enable-ssl";

  meta = {
    homepage = http://irssi.org;
  };
}

{stdenv, fetchurl, pkgconfig, ncurses, glib, openssl}:

stdenv.mkDerivation {
  name = "irssi-0.8.11";
  src = fetchurl {
    url = http://irssi.org/files/irssi-0.8.11.tar.bz2;
    sha256 = "425cf24f13bfda05c6a468523cd2874d05675ea1bc4e37a8c284f2f78c2dd6b2";
  };
  buildInputs = [pkgconfig ncurses glib openssl];
  NIX_LDFLAGS = "-lncurses";
  configureFlags = "--with-proxy --with-ncurses --enable-ssl";
}

{stdenv, fetchurl, pkgconfig, ncurses, glib, openssl}:

stdenv.mkDerivation rec {
  name = "irssi-0.8.13";
  
  src = fetchurl {
    url = "http://irssi.org/files/${name}.tar.bz2";
    sha256 = "0dfp0lmnw5ndl2a9lj2rc8rg1lylcjrqlrg26h4jj8blhfn42rc9";
  };
  
  buildInputs = [pkgconfig ncurses glib openssl];
  
  NIX_LDFLAGS = "-lncurses";
  
  configureFlags = "--with-proxy --with-ncurses --enable-ssl";

  meta = {
    homepage = http://irssi.org;
  };
}

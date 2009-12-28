{stdenv, fetchurl, pkgconfig, ncurses, glib, openssl}:

stdenv.mkDerivation rec {
  name = "irssi-0.8.14";
  
  src = fetchurl {
    url = "http://irssi.org/files/${name}.tar.bz2";
    sha256 = "0a6zizpqb4yyk7c9sxvqcj8jx20qrnfr2kwqbsckryz63kmp1sk3";
  };
  
  buildInputs = [pkgconfig ncurses glib openssl];
  
  NIX_LDFLAGS = "-lncurses";
  
  configureFlags = "--with-proxy --with-ncurses --enable-ssl";

  meta = {
    homepage = http://irssi.org;
  };
}

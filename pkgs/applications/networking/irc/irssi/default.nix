{ stdenv, fetchurl, pkgconfig, ncurses, glib, openssl, perl, libintlOrEmpty }:

stdenv.mkDerivation rec {
  version = "1.0.5";
  name = "irssi-${version}";

  src = fetchurl {
    url = "https://github.com/irssi/irssi/releases/download/${version}/${name}.tar.gz";
    sha256 = "1lasb8flic4qc1sd3pvfg9aig5skcxlyx6iy9bk73147r8vzaq75";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses glib openssl perl libintlOrEmpty ];

  configureFlags = [
    "--with-proxy"
    "--with-bot"
    "--with-perl=yes"
    "--enable-true-color"
  ];

  meta = {
    homepage    = http://irssi.org;
    description = "A terminal based IRC client";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
  };
}

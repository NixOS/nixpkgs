{ stdenv, fetchurl, pkgconfig, ncurses, glib, openssl, perl, libintlOrEmpty }:

stdenv.mkDerivation rec {
  version = "1.0.2";
  name = "irssi-${version}";

  src = fetchurl {
    url = "https://github.com/irssi/irssi/releases/download/${version}/${name}.tar.gz";
    sha256 = "1fas6dqz6g8m2400spvkhfxihj3w06qb917h4vhcb716g9wpjkwf";
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

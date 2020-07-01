{ stdenv, fetchurl, pkgconfig, ncurses, glib, openssl, perl, libintl, libgcrypt, libotr }:

stdenv.mkDerivation rec {
  pname = "irssi";
  version = "1.2.2";

  src = fetchurl {
    url = "https://github.com/irssi/irssi/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0g2nxazn4lszmd6mf1s36x5ablk4999g1qx7byrnvgnjsihjh62k";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses glib openssl perl libintl libgcrypt libotr ];

  configureFlags = [
    "--with-proxy"
    "--with-bot"
    "--with-perl=yes"
    "--with-otr=yes"
    "--enable-true-color"
  ];

  meta = {
    homepage    = "https://irssi.org";
    description = "A terminal based IRC client";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    license     = stdenv.lib.licenses.gpl2Plus;
  };
}

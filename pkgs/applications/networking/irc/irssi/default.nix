{ lib, stdenv, fetchurl, pkg-config, ncurses, glib, openssl, perl, libintl, libgcrypt, libotr }:

stdenv.mkDerivation rec {
  pname = "irssi";
  version = "1.2.3";

  src = fetchurl {
    url = "https://github.com/irssi/irssi/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "09cwz5ff1i5lp35qhhmw6kbw5dwcn9pl16gpzkc92xg5sx3bgjr9";
  };

  nativeBuildInputs = [ pkg-config ];
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
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ lovek323 ];
    license     = lib.licenses.gpl2Plus;
  };
}

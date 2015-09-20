{ stdenv, fetchurl, automake, autoconf, pkgconfig, glib, openssl, expat
, ncurses, libotr, curl, libstrophe, readline, libuuid

, autoAwaySupport ? false, libXScrnSaver ? null, libX11 ? null
, notifySupport ? false,   libnotify ? null, gdk_pixbuf ? null
}:

assert autoAwaySupport -> libXScrnSaver != null && libX11 != null;
assert notifySupport   -> libnotify != null && gdk_pixbuf != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "profanity-${version}";
  version = "0.4.7";

  src = fetchurl {
    url = "http://www.profanity.im/profanity-${version}.tar.gz";
    sha256 = "1p8ixvxacvf63r6lnf6iwlyz4pgiyp6widna1h2l2jg8kw14wb5h";
  };

  buildInputs = [
    automake autoconf pkgconfig readline libuuid
    glib openssl expat ncurses libotr curl libstrophe
  ] ++ optionals autoAwaySupport [ libXScrnSaver libX11 ]
    ++ optionals notifySupport   [ libnotify gdk_pixbuf ];

  preConfigure = "sh bootstrap.sh";

  meta = {
    description = "A console based XMPP client";
    longDescription = ''
      Profanity is a console based XMPP client written in C using ncurses and
      libstrophe, inspired by Irssi.
    '';
    homepage = http://profanity.im/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.devhell ];
  };
}

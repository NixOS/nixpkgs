{ stdenv, fetchurl, automake, autoconf, pkgconfig, glib, openssl, expat
, ncurses, libotr, curl, libstrophe

, autoAwaySupport ? false, libXScrnSaver ? null, libX11 ? null
, notifySupport ? false,   libnotify ? null, gdk_pixbuf ? null
}:

assert autoAwaySupport -> libXScrnSaver != null && libX11 != null;
assert notifySupport   -> libnotify != null && gdk_pixbuf != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "profanity-${version}";
  version = "0.4.5";

  src = fetchurl {
    url = "http://www.profanity.im/profanity-${version}.tar.gz";
    sha256 = "0qzwqxcxf695z3gf94psd2x619vlp4hkkjmkrpsla1ns0f6v6dkl";
  };

  buildInputs = [
    automake autoconf pkgconfig
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

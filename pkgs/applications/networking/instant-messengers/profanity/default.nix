{ stdenv, fetchurl, automake, autoconf, pkgconfig, glib, openssl, expat
, ncurses, libotr, curl, libstrophe

, notifySupport ? false, libnotify ? null, libXScrnSaver ? null
,                        libX11 ? null, gdk_pixbuf ? null
}:

assert notifySupport -> libnotify != null && libXScrnSaver != null
                     && libX11 != null && gdk_pixbuf != null;

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
  ] ++ optionals notifySupport [ libnotify libXScrnSaver libX11 gdk_pixbuf ];

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

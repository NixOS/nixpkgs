/**
 * Possible missing configuration:
 *
 * - silcclient
 * - libebook-1.2
 * - libedata-book-1.2
 * - checking for XScreenSaverRegister in -lXext... no
 * - checking for XScreenSaverRegister in -lXss... no
 * - ao
 * - audiofile-config
 * - doxygen
 */
{ stdenv, fetchurl, pkgconfig, gtk, gtkspell, aspell,
  GStreamer, startupnotification, gettext,
  perl, perlXMLParser, libxml2, openssl, nss,
  libXScrnSaver, ncurses
} :

stdenv.mkDerivation {
  name = "pidgin-2.1.0";
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/pidgin/pidgin-2.1.0.tar.bz2;
    sha256 = "1y552n75pp4rrnmmpmfyym1w18589n3600xsq7b2bjx6rk66kgkr";
  };

  inherit nss ncurses;
  buildInputs = [
    gtkspell aspell
    GStreamer startupnotification
    libxml2 openssl nss
    libXScrnSaver ncurses
  ];

  propagatedBuildInputs = [
    pkgconfig gtk perl perlXMLParser gettext
  ];

  configureFlags="--with-nspr-includes=${nss}/include/nspr --with-nspr-libs=${nss}/lib --with-nss-includes=${nss}/include/nss --with-nss-libs=${nss}/lib --with-ncurses-headers=${ncurses}/include";
  meta = {
    description = "Pidgin IM - XMPP(Jabber), AIM/ICQ, IRC, SIP etc client.";
  };
}

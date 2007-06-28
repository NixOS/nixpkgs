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
  name = "pidgin-2.0.1";
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/pidgin/pidgin-2.0.1.tar.bz2;
    sha256 = "1z2is5hp77qc5lw200jf0d1rai4gp83q2kl9x06ra026c2591yc0";
  };

  inherit nss ncurses;
  buildInputs = [
    pkgconfig gtk gtkspell aspell
    GStreamer startupnotification gettext
    perl perlXMLParser libxml2 openssl nss
    libXScrnSaver ncurses
  ];
  configureFlags="--with-nspr-includes=${nss}/include/nspr --with-nspr-libs=${nss}/lib --with-nss-includes=${nss}/include/nss --with-nss-libs=${nss}/lib --with-ncurses-headers=${ncurses}/include";
  meta = {
    description = "Pidgin IM - XMPP(Jabber), AIM/ICQ, IRC, SIP etc client.";
  };
}

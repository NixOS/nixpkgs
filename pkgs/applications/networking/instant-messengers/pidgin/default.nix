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
  perl, perlXMLParser, libxml2, nss,
  libXScrnSaver, ncurses, avahi, dbus, dbus_glib
  , lib
  , openssl ? null
  , gnutls ? null
} :

stdenv.mkDerivation {
  name = "pidgin-2.5.1";
  src = fetchurl {
    url = mirror://sourceforge/pidgin/pidgin-2.5.1.tar.bz2;
    sha256 = "0xsvwy2d71lxddmyzm5fjripbhy1ljph4r2nz1rbw11qnj47ms0k";
  };

  inherit nss ncurses;
  buildInputs = [
    gtkspell aspell
    GStreamer startupnotification
    libxml2] 
  ++ (lib.optional (openssl != null) openssl)
  ++ (lib.optional (gnutls != null) gnutls)
  ++
  [nss
    libXScrnSaver ncurses
    avahi dbus dbus_glib
  ]
  ;

  propagatedBuildInputs = [
    pkgconfig gtk perl perlXMLParser gettext
  ];

  configureFlags="--with-nspr-includes=${nss}/include/nspr --with-nspr-libs=${nss}/lib --with-nss-includes=${nss}/include/nss --with-nss-libs=${nss}/lib --with-ncurses-headers=${ncurses}/include --disable-meanwhile --disable-nm --disable-tcl";
  meta = {
    description = "Pidgin IM - XMPP(Jabber), AIM/ICQ, IRC, SIP etc client.";
    homepage = http://pidgin.im;
  };
}

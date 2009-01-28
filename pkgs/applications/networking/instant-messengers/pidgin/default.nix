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
  libXScrnSaver, ncurses, avahi, dbus, dbus_glib, intltool
  , lib
  , openssl ? null
  , gnutls ? null
} :

stdenv.mkDerivation {
  name = "pidgin-2.5.4";
  src = fetchurl {
    url = mirror://sourceforge/pidgin/pidgin-2.5.4.tar.bz2;
    sha256 = "0qqvv9x5p2yxmw57sj3hvc10vxpd9mqv61w1pk97qcwbggwvxgn6";
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
    avahi dbus dbus_glib intltool
  ]
  ;

  propagatedBuildInputs = [
    pkgconfig gtk perl perlXMLParser gettext
  ];

  configureFlags="--with-nspr-includes=${nss}/include/nspr --with-nspr-libs=${nss}/lib --with-nss-includes=${nss}/include/nss --with-nss-libs=${nss}/lib --with-ncurses-headers=${ncurses}/include --disable-meanwhile --disable-nm --disable-tcl"
  + (lib.optionalString (gnutls != null) " --enable-gnutls=yes --enable-nss=no")
  ;
  meta = {
    description = "Pidgin IM - XMPP(Jabber), AIM/ICQ, IRC, SIP etc client.";
    homepage = http://pidgin.im;
  };
}

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
  GStreamer, gstPluginsBase, startupnotification, gettext,
  perl, perlXMLParser, libxml2, nss, nspr, farsight2,
  libXScrnSaver, ncurses, avahi, dbus, dbus_glib, intltool, libidn
  , lib
  , openssl ? null
  , gnutls ? null
  , voice ? null
} :

stdenv.mkDerivation {
  name = "pidgin-2.6.4";
  src = fetchurl {
    url = mirror://sourceforge/pidgin/pidgin-2.6.4.tar.bz2;
    sha256 = "04dyr2g45i3wr67zsn04pjl6vyvic8dchb73pajf823pa377m47s";
  };

  inherit nss ncurses;
  buildInputs = [
    gtkspell aspell
    GStreamer gstPluginsBase startupnotification
    libxml2] 
  ++ (lib.optional (openssl != null) openssl)
  ++ (lib.optional (gnutls != null) gnutls)
  ++
  [nss nspr farsight2
    libXScrnSaver ncurses
    avahi dbus dbus_glib intltool libidn
  ]
  ;

  propagatedBuildInputs = [
    pkgconfig gtk perl perlXMLParser gettext
  ];

  patches = [./pidgin-makefile.patch];

  configureFlags="--with-nspr-includes=${nspr}/include/nspr --with-nspr-libs=${nspr}/lib --with-nss-includes=${nss}/include/nss --with-nss-libs=${nss}/lib --with-ncurses-headers=${ncurses}/include --disable-meanwhile --disable-nm --disable-tcl"
  + (lib.optionalString (gnutls != null) " --enable-gnutls=yes --enable-nss=no")
  ;
  meta = {
    description = "Pidgin IM - XMPP(Jabber), AIM/ICQ, IRC, SIP etc client.";
    homepage = http://pidgin.im;
  };
}

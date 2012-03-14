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
  gstreamer, gst_plugins_base, startupnotification, gettext,
  perl, perlXMLParser, libxml2, nss, nspr, farsight2,
  libXScrnSaver, ncurses, avahi, dbus, dbus_glib, intltool, libidn
  , lib, python
  , openssl ? null
  , gnutls ? null
  , libgcrypt ? null
} :

stdenv.mkDerivation {
  name = "pidgin-2.9.0";
  src = fetchurl {
    url = mirror://sourceforge/pidgin/pidgin-2.10.1.tar.bz2;
    sha256 = "2f28bddc5edcd714d607d74126c8958ae7c258602b3929e3e6e783d3cb1beac8";
  };

  inherit nss ncurses;
  buildInputs = [
    gtkspell aspell
    gstreamer gst_plugins_base startupnotification
    libxml2] 
  ++ (lib.optional (openssl != null) openssl)
  ++ (lib.optional (gnutls != null) gnutls)
  ++ (lib.optional (libgcrypt != null) libgcrypt)
  ++
  [nss nspr farsight2
    libXScrnSaver ncurses python
    avahi dbus dbus_glib intltool libidn
  ]
  ;

  propagatedBuildInputs = [
    pkgconfig gtk perl perlXMLParser gettext
  ];

  patches = [./pidgin-makefile.patch ];

  configureFlags="--with-nspr-includes=${nspr}/include/nspr --with-nspr-libs=${nspr}/lib --with-nss-includes=${nss}/include/nss --with-nss-libs=${nss}/lib --with-ncurses-headers=${ncurses}/include --disable-meanwhile --disable-nm --disable-tcl"
  + (lib.optionalString (gnutls != null) " --enable-gnutls=yes --enable-nss=no")
  ;
  meta = {
    description = "Pidgin IM - XMPP(Jabber), AIM/ICQ, IRC, SIP etc client.";
    homepage = http://pidgin.im;
  };
}

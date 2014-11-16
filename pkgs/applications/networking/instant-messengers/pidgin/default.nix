{ stdenv, fetchurl, pkgconfig, gtk, gtkspell, aspell
, gstreamer, gst_plugins_base, startupnotification, gettext
, perl, perlXMLParser, libxml2, nss, nspr, farsight2
, libXScrnSaver, ncurses, avahi, dbus, dbus_glib, intltool, libidn
, lib, python, libICE, libXext, libSM
, openssl ? null
, gnutls ? null
, libgcrypt ? null
}:

# FIXME: clean the mess around choosing the SSL library (nss by default)

stdenv.mkDerivation rec {
  name = "pidgin-${version}";
  version = "2.10.10";

  src = fetchurl {
    url = "mirror://sourceforge/pidgin/${name}.tar.bz2";
    sha256 = "0bc2bk2g3w90mpz9sn9j95c71z4i2i3wxaqa2zpmmixf5r8rasyw";
  };

  inherit nss ncurses;

  buildInputs = [
    gtkspell aspell
    gstreamer gst_plugins_base startupnotification
    libxml2 nss nspr farsight2
    libXScrnSaver ncurses python
    avahi dbus dbus_glib intltool libidn
    libICE libXext libSM
  ]
  ++ (lib.optional (openssl != null) openssl)
  ++ (lib.optional (gnutls != null) gnutls)
  ++ (lib.optional (libgcrypt != null) libgcrypt);

  propagatedBuildInputs = [
    pkgconfig gtk perl perlXMLParser gettext
  ];

  patches = [./pidgin-makefile.patch ./add-search-path.patch ];

  configureFlags = [
    "--with-nspr-includes=${nspr}/include/nspr"
    "--with-nspr-libs=${nspr}/lib"
    "--with-nss-includes=${nss}/include/nss"
    "--with-nss-libs=${nss}/lib"
    "--with-ncurses-headers=${ncurses}/include"
    "--disable-meanwhile"
    "--disable-nm"
    "--disable-tcl"
  ]
  ++ (lib.optionals (gnutls != null) ["--enable-gnutls=yes" "--enable-nss=no"]);

  meta = with stdenv.lib; {
    description = "Multi-protocol instant messaging client";
    homepage = http://pidgin.im;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.vcunat ];
  };
}

{ stdenv, fetchurl, makeWrapper, pkgconfig, gtk, gtkspell, aspell
, gstreamer, gst_plugins_base, gst_plugins_good, startupnotification, gettext
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
  majorVersion = "2";
  version = "${majorVersion}.10.11";

  src = fetchurl {
    url = "mirror://sourceforge/pidgin/${name}.tar.bz2";
    sha256 = "01s0q30qrjlzj7kkz6f8lvrwsdd55a9yjh2xjjwyyxzw849j3bpj";
  };

  inherit nss ncurses;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    gtkspell aspell
    gstreamer gst_plugins_base gst_plugins_good startupnotification
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

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/pidgin \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Multi-protocol instant messaging client";
    homepage = http://pidgin.im;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.vcunat ];
  };
}

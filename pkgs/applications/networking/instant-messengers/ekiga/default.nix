{ stdenv, fetchurl, cyrus_sasl, gettext, openldap, ptlib, opal, libXv, rarian, intltool
, perl, perlXMLParser, evolution_data_server, gnome_doc_utils, avahi, autoreconfHook
, libsigcxx, gtk, dbus_glib, libnotify, libXext, xextproto, gnome3, boost, libsecret
, pkgconfig, libxml2, videoproto, unixODBC, db, nspr, nss, zlib, hicolor_icon_theme
, libXrandr, randrproto, which, libxslt, libtasn1, gmp, nettle, sqlite, makeWrapper }:

stdenv.mkDerivation rec {
  name = "ekiga-4.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/ekiga/4.0/${name}.tar.xz";
    sha256 = "5f4f491c9496cf65ba057a9345d6bb0278f4eca07bcda5baeecf50bfcd9a4a3b";
  };

  buildInputs = [ cyrus_sasl gettext openldap ptlib opal libXv rarian intltool
                  perl perlXMLParser evolution_data_server gnome_doc_utils avahi
                  libsigcxx gtk dbus_glib libnotify libXext xextproto sqlite
                  gnome3.libsoup
                  hicolor_icon_theme gnome3.gnome_icon_theme boost autoreconfHook
                  pkgconfig libxml2 videoproto unixODBC db nspr nss zlib libsecret
                  libXrandr randrproto which libxslt libtasn1 gmp nettle makeWrapper ];

  preAutoreconf = ''
    substituteInPlace configure.ac --replace AM_GCONF_SOURCE_2 ""
  '';

  configureFlags = [
    "--with-ldap-dir=${openldap}"
    "--with-libsasl2-dir=${cyrus_sasl}"
    "--with-boost-libdir=${boost}/lib"
    "--disable-gconf"
  ];

  enableParallelBuilding = true;

  patches = [ ./autofoo.patch ./boost.patch ];

  postInstall = ''
    wrapProgram "$out"/bin/ekiga \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Ekiga SIP client";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };

  passthru = {
    updateInfo = {
      downloadPage = "mirror://gnome/sources/ekiga";
    };
  };
}


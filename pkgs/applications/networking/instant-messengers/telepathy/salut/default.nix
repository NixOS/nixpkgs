{ stdenv, fetchurl, libxslt, glib, libxml2, telepathy_glib, avahi, libsoup
, libuuid, gnutls, sqlite, pkgconfigUpstream }:

stdenv.mkDerivation rec {
  pname = "telepathy-salut";
  name = "${pname}-0.8.0";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "1kmmpwjbfph37bjvpkfphff8dzhr896i55knf311f778fbsgl17m";
  };

  buildInputs = [ glib libxml2 telepathy_glib avahi libsoup libuuid gnutls
    sqlite ];

  nativeBuildInputs = [ libxslt pkgconfigUpstream ];

  configureFlags = "--disable-avahi-tests";

  meta = {
    description = "Link-local XMPP connection manager for Telepathy";
    platforms = stdenv.lib.platforms.gnu; # Random choice
  };
}

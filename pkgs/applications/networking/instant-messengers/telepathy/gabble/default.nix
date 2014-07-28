{ stdenv, fetchurl, pkgconfig, libxslt, telepathy_glib, libxml2, dbus_glib
, sqlite, libsoup, libnice, gnutls }:

stdenv.mkDerivation rec {
  name = "telepathy-gabble-0.17.2";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-gabble/${name}.tar.gz";
    sha256 = "137sslbgh0326lmwihcr2ybljgq9mzsx5wnciilpx884si22wpk8";
  };

  nativeBuildInputs = [ pkgconfig libxslt ];
  buildInputs = [ libxml2 dbus_glib sqlite libsoup libnice telepathy_glib gnutls ];

  configureFlags = "--with-ca-certificates=/etc/ssl/certs/ca-bundle.crt";

  meta = {
    homepage = http://telepathy.freedesktop.org;
    description = "Jabber/XMPP connection manager for the Telepathy framework";
    platforms = stdenv.lib.platforms.gnu;
  };
}

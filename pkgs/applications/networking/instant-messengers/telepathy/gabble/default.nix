{ stdenv, fetchurl, pkgconfig, libxslt, telepathy_glib, libxml2, dbus_glib, dbus_daemon
, sqlite, libsoup, libnice, gnutls }:

stdenv.mkDerivation rec {
  name = "telepathy-gabble-0.18.2";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-gabble/${name}.tar.gz";
    sha256 = "00ag32ccbj0hmy41rb0fg9gp40m7zbq45r4yijnyslk2mpkvg7c9";
  };

  nativeBuildInputs = [ pkgconfig libxslt ];
  buildInputs = [ libxml2 dbus_glib sqlite libsoup libnice telepathy_glib gnutls ]
    ++ stdenv.lib.optional doCheck dbus_daemon;

  configureFlags = "--with-ca-certificates=/etc/ssl/certs/ca-bundle.crt";

  enableParallelBuilding = true;
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://telepathy.freedesktop.org;
    description = "Jabber/XMPP connection manager for the Telepathy framework";
    platforms = stdenv.lib.platforms.gnu;
  };
}

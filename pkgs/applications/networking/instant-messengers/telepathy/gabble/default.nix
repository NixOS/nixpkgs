{ stdenv, fetchurl, pkgconfig, libxslt, telepathy-glib, libxml2, dbus-glib, dbus_daemon
, sqlite, libsoup, libnice, gnutls}:

stdenv.mkDerivation rec {
  name = "telepathy-gabble-0.18.3";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-gabble/${name}.tar.gz";
    sha256 = "1hl9k6jwn2afwwv7br16wfw5szdhwxqziba47xd8vjwvgrh19iwf";
  };

  nativeBuildInputs = [ pkgconfig libxslt ];
  buildInputs = [ libxml2 dbus-glib sqlite libsoup libnice telepathy-glib gnutls telepathy-glib.python ]
    ++ stdenv.lib.optional doCheck dbus_daemon;

  configureFlags = "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt";

  enableParallelBuilding = true;
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://telepathy.freedesktop.org/components/telepathy-gabble/;
    description = "Jabber/XMPP connection manager for the Telepathy framework";
    license = licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.gnu;
  };
}

{ stdenv, fetchurl, pkgconfig, libxslt, telepathy-glib, libxml2, dbus-glib, dbus_daemon
, sqlite, libsoup, libnice, gnutls}:

stdenv.mkDerivation rec {
  name = "telepathy-gabble-0.18.4";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/telepathy-gabble/${name}.tar.gz";
    sha256 = "174nlkqm055vrhv11gy73m20jbsggcb0ddi51c7s9m3j5ibr2p0i";
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

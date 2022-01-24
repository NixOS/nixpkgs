{ lib, stdenv, fetchurl, pkg-config, libxslt, telepathy-glib, python2, libxml2, dbus-glib, dbus
, sqlite, libsoup, libnice, gnutls}:

stdenv.mkDerivation rec {
  pname = "telepathy-gabble";
  version = "0.18.4";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/telepathy-gabble/telepathy-gabble-${version}.tar.gz";
    sha256 = "174nlkqm055vrhv11gy73m20jbsggcb0ddi51c7s9m3j5ibr2p0i";
  };

  nativeBuildInputs = [ pkg-config libxslt ];
  buildInputs = [ libxml2 dbus-glib sqlite libsoup libnice telepathy-glib gnutls python2 ];

  checkInputs = [ dbus.daemon ];

  configureFlags = [ "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt" ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = with lib; {
    homepage = "https://telepathy.freedesktop.org/components/telepathy-gabble/";
    description = "Jabber/XMPP connection manager for the Telepathy framework";
    license = licenses.lgpl21Plus;
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
  };
}

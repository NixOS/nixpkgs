{ stdenv, fetchurl, libxslt, glib, libxml2, telepathy_glib, avahi, libsoup
, libuuid, gnutls, sqlite, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "telepathy-salut";
  name = "${pname}-0.7.2";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "0vahmqi78pbmsn472kijl3d4rshz07pmihxk5xkp99hvbqd4mb1f";
  };

  buildInputs = [ glib libxml2 telepathy_glib avahi libsoup libuuid gnutls
    sqlite ];

  buildNativeInputs = [ libxslt pkgconfig ];

  configureFlags = "--disable-avahi-tests";

  meta = {
    description = "Link-local XMPP connection manager for Telepathy";
    platforms = stdenv.lib.platforms.gnu; # Random choice
  };
}

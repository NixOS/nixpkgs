{ stdenv, fetchurl, libxslt, glib, libxml2, telepathy_glib, avahi, libsoup
, libuuid, openssl, sqlite, pkgconfigUpstream }:

stdenv.mkDerivation rec {
  pname = "telepathy-salut";
  name = "${pname}-0.8.1";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "13k112vrr3zghzr03pnbqc1id65qvpj0sn0virlbf4dmr2511fbh";
  };

  buildInputs = [ glib libxml2 telepathy_glib avahi libsoup libuuid openssl
    sqlite ];

  nativeBuildInputs = [ libxslt pkgconfigUpstream ];

  configureFlags = "--disable-avahi-tests";

  meta = {
    description = "Link-local XMPP connection manager for Telepathy";
    platforms = stdenv.lib.platforms.gnu; # Random choice
  };
}

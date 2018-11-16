{ stdenv, fetchurl, libxslt, glib, libxml2, telepathy-glib, avahi, libsoup
, libuuid, openssl, pcre, sqlite, pkgconfigUpstream }:

stdenv.mkDerivation rec {
  pname = "telepathy-salut";
  name = "${pname}-0.8.1";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "13k112vrr3zghzr03pnbqc1id65qvpj0sn0virlbf4dmr2511fbh";
  };

  # pcre needed because https://github.com/NixOS/nixpkgs/pull/15046
  buildInputs = [ glib libxml2 telepathy-glib avahi libsoup libuuid openssl
    sqlite pcre telepathy-glib.python ];

  nativeBuildInputs = [ libxslt pkgconfigUpstream ];

  configureFlags = [ "--disable-avahi-tests" ];

  meta = with stdenv.lib; {
    description = "Link-local XMPP connection manager for Telepathy";
    platforms = platforms.gnu ++ platforms.linux; # Random choice
    maintainers = [ maintainers.lethalman ];
  };
}

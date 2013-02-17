{ stdenv, fetchurl, pidgin, telepathy_glib, glib, dbus_glib, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  pname = "telepathy-haze";
  name = "${pname}-0.6.0";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${pname}/${name}.tar.gz";
    sha256 = "1qrgmcr8ga6nvaz9hhn0mv0p7v799wsawrg3k5l791cgxx5carz2";
  };

  buildInputs = [ glib telepathy_glib dbus_glib pidgin ];

  nativeBuildInputs = [ pkgconfig libxslt ];

  meta = {
    description = "A Telepathy connection manager based on libpurple";
    platforms = stdenv.lib.platforms.gnu; # Random choice
  };
}

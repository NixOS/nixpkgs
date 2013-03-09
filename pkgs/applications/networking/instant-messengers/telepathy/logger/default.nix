{ stdenv, fetchurl, dbus_glib, libxml2, sqlite, telepathy_glib, pkgconfig
, intltool, libxslt }:

stdenv.mkDerivation rec {
  project = "telepathy-logger";
  name = "${project}-0.8.0";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${project}/${name}.tar.bz2";
    sha256 = "18i00l8lnp5dghqmgmpxnn0is2a20pkisxy0sb78hnd2dz0z6xnl";
  };

  buildInputs = [ dbus_glib libxml2 sqlite telepathy_glib pkgconfig intltool ];

  nativeBuildInputs = [ libxslt ];

  configureFlags = "--enable-call";

  meta = {
    description = "Logger service for Telepathy framework";
    homepage = http://telepathy.freedesktop.org/wiki/Logger ;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.gnu; # Arbitrary choice
  };
}

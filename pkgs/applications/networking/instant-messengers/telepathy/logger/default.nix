{ stdenv, fetchurl, dbus_glib, libxml2, sqlite, telepathy_glib, pkgconfig
, intltool, libxslt }:

stdenv.mkDerivation rec {
  project = "telepathy-logger";
  name = "${project}-0.4.0";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${project}/${name}.tar.bz2";
    sha256 = "1rb58ipz56c9bac8b31md5gk1fw7jim8x9dx3cm5gmxg2q3apd86";
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

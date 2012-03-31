{ stdenv, fetchurl, dbus_glib, libxml2, sqlite, telepathy_glib, pkgconfig
, intltool, libxslt }:

stdenv.mkDerivation rec {
  project = "telepathy-logger";
  name = "${project}-0.2.12";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${project}/${name}.tar.bz2";
    sha256 = "1681m1j6vqzy089fnbfpz9i8jsg64fq6x6kf25b9p2090dnqrkj3";
  };

  buildInputs = [ dbus_glib libxml2 sqlite telepathy_glib pkgconfig intltool ];

  buildNativeInputs = [ libxslt ];

  configureFlags = "--enable-call";

  meta = {
    description = "Logger service for Telepathy framework";
    homepage = http://telepathy.freedesktop.org/wiki/Logger ;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.gnu; # Arbitrary choice
  };
}

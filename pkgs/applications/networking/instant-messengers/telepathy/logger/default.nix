{ stdenv, fetchurl, dbus_glib, libxml2, sqlite, telepathy_glib, pkgconfig
, gnome3, makeWrapper, intltool, libxslt, gobjectIntrospection, dbus_libs }:

stdenv.mkDerivation rec {
  project = "telepathy-logger";
  name = "${project}-0.8.0";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${project}/${name}.tar.bz2";
    sha256 = "18i00l8lnp5dghqmgmpxnn0is2a20pkisxy0sb78hnd2dz0z6xnl";
  };

  NIX_CFLAGS_COMPILE = "-I${dbus_glib.dev}/include/dbus-1.0 -I${dbus_libs.dev}/include/dbus-1.0";

  buildInputs = [ dbus_glib libxml2 sqlite telepathy_glib pkgconfig intltool makeWrapper
                  gobjectIntrospection dbus_libs telepathy_glib.python (stdenv.lib.getLib gnome3.dconf) ];

  nativeBuildInputs = [ libxslt ];

  configureFlags = "--enable-call";

  preFixup = ''
    wrapProgram "$out/libexec/telepathy-logger" \
      --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib gnome3.dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = {
    description = "Logger service for Telepathy framework";
    homepage = http://telepathy.freedesktop.org/wiki/Logger ;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu; # Arbitrary choice
  };
}

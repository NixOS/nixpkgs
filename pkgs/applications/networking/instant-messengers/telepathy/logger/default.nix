{ stdenv, fetchurl, dbus-glib, libxml2, sqlite, telepathy-glib, pkgconfig
, gnome3, makeWrapper, intltool, libxslt, gobjectIntrospection, dbus_libs }:

stdenv.mkDerivation rec {
  project = "telepathy-logger";
  name = "${project}-0.8.2";

  src = fetchurl {
    url = "http://telepathy.freedesktop.org/releases/${project}/${name}.tar.bz2";
    sha256 = "18i00l8lnp5dghqmgmpxnn0is2a20pkisxy0sb78hnd2dz0z6xnl";
  };

  nativeBuildInputs = [
    makeWrapper pkgconfig intltool libxslt gobjectIntrospection
  ];
  buildInputs = [
    dbus-glib libxml2 sqlite telepathy-glib
    dbus_libs telepathy-glib.python
  ];

  configureFlags = "--enable-call";

  preFixup = ''
    wrapProgram "$out/libexec/telepathy-logger" \
      --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib gnome3.dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Logger service for Telepathy framework";
    homepage = https://telepathy.freedesktop.org/components/telepathy-logger/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.gnu; # Arbitrary choice
  };
}

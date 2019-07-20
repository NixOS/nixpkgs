{ stdenv, fetchurl, dbus-glib, libxml2, sqlite, telepathy-glib, pkgconfig
, gnome3, makeWrapper, intltool, libxslt, gobject-introspection, dbus }:

stdenv.mkDerivation rec {
  project = "telepathy-logger";
  name = "${project}-0.8.2";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/${project}/${name}.tar.bz2";
    sha256 = "1bjx85k7jyfi5pvl765fzc7q2iz9va51anrc2djv7caksqsdbjlg";
  };

  nativeBuildInputs = [
    makeWrapper pkgconfig intltool libxslt gobject-introspection
  ];
  buildInputs = [
    dbus-glib libxml2 sqlite telepathy-glib
    dbus telepathy-glib.python
  ];

  configureFlags = [ "--enable-call" ];

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
    platforms = platforms.gnu ++ platforms.linux; # Arbitrary choice
  };
}

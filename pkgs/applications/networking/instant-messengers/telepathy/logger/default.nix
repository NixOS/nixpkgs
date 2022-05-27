{ lib, stdenv, fetchurl, dbus-glib, libxml2, sqlite, telepathy-glib, python2, pkg-config
, dconf, makeWrapper, intltool, libxslt, gobject-introspection, dbus }:

stdenv.mkDerivation rec {
  pname = "telepathy-logger";
  version = "0.8.2";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-${version}.tar.bz2";
    sha256 = "1bjx85k7jyfi5pvl765fzc7q2iz9va51anrc2djv7caksqsdbjlg";
  };

  nativeBuildInputs = [
    makeWrapper pkg-config intltool libxslt gobject-introspection
  ];
  buildInputs = [
    dbus-glib libxml2 sqlite telepathy-glib
    dbus python2
  ];

  configureFlags = [ "--enable-call" ];

  preFixup = ''
    wrapProgram "$out/libexec/telepathy-logger" \
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with lib; {
    description = "Logger service for Telepathy framework";
    homepage = "https://telepathy.freedesktop.org/components/telepathy-logger/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
    platforms = platforms.gnu ++ platforms.linux; # Arbitrary choice
  };
}

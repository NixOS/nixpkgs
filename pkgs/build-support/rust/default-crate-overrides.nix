{ pkgconfig, sqlite, openssl, dbus_libs, dbus_glib, gdk_pixbuf, cairo, python3, ... }:

{
  libsqlite3-sys = attrs: {
    buildInputs = [ pkgconfig sqlite ];
  };
  openssl-sys = attrs: {
    buildInputs = [ pkgconfig openssl ];
  };
  dbus = attrs: {
    buildInputs = [ pkgconfig dbus_libs ];
  };
  libdbus-sys = attrs: {
    buildInputs = [ pkgconfig dbus_libs ];
  };
  gobject-sys = attrs: {
    buildInputs = [ dbus_glib ];
  };
  gio-sys = attrs: {
    buildInputs = [ dbus_glib ];
  };
  gdk-pixbuf-sys = attrs: {
    buildInputs = [ dbus_glib ];
  };
  gdk-pixbuf = attrs: {
    buildInputs = [ gdk_pixbuf ];
  };
  cairo-rs = attrs: {
    buildInputs = [ cairo ];
  };
  xcb = attrs: {
    buildInputs = [ python3 ];
  };
}

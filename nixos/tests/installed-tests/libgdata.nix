{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.libgdata;

  testConfig = {
    # # GLib-GIO-DEBUG: _g_io_module_get_default: Found default implementation dummy (GDummyTlsBackend) for ‘gio-tls-backend’
    # Bail out! libgdata:ERROR:../gdata/tests/common.c:134:gdata_test_init: assertion failed (child_error == NULL): TLS support is not available (g-tls-error-quark, 0)
    services.gnome.glib-networking.enable = true;
  };
}

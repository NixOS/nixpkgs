# run installed tests
import ./make-test.nix ({ pkgs, ... }:

{
  name = "libgdata";

  meta = {
    maintainers = pkgs.libgdata.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ gnome-desktop-testing ];
    # # GLib-GIO-DEBUG: _g_io_module_get_default: Found default implementation dummy (GDummyTlsBackend) for ‘gio-tls-backend’
    # Bail out! libgdata:ERROR:../gdata/tests/common.c:134:gdata_test_init: assertion failed (child_error == NULL): TLS support is not available (g-tls-error-quark, 0)
    services.gnome3.glib-networking.enable = true;
  };

  testScript = ''
    $machine->succeed("gnome-desktop-testing-runner -d '${pkgs.libgdata.installedTests}/share'");
  '';
})

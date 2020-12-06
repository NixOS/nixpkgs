import ./make-test-python.nix ({ pkgs, ... }: {
  name = "packagekit";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ peterhoeg ];
  };

  machine = { ... }: {
    environment.systemPackages = with pkgs; [ dbus ];
    services.packagekit = {
      enable = true;
      backend = "test_nop";
    };
  };

  testScript = ''
    start_all()

    # send a dbus message to activate the service
    machine.succeed(
        "dbus-send --system --type=method_call --print-reply --dest=org.freedesktop.PackageKit /org/freedesktop/PackageKit org.freedesktop.DBus.Introspectable.Introspect"
    )

    # so now it should be running
    machine.wait_for_unit("packagekit.service")
  '';
})

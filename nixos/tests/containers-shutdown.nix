import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "containers-shutdown";

  machine = { pkgs, ... }: {
    containers.autostart = {
      autoStart = true;
      config = {};
    };

    containers.triggered = {
      config = {};
    };
  };

  testScript = ''
    assert "autostart" in machine.succeed("nixos-container list")
    assert "triggered" in machine.succeed("nixos-container list")

    machine.wait_for_unit("machines.target")

    # stopping either machined or dbus must stop all containers.

    machine.succeed("nixos-container start triggered")
    machine.systemctl("stop systemd-machined.service")
    machine.wait_until_fails("systemctl is-active systemd-machined.service")
    machine.fail("systemctl is-active container@active.service")
    machine.fail("systemctl is-active container@triggered.service")

    machine.systemctl("start container@autostart.service")
    machine.succeed("nixos-container start triggered")
    machine.succeed("systemctl stop dbus.service")
    machine.wait_until_fails("systemctl is-active dbus.service")
    machine.fail("systemctl is-active container@active.service")
    machine.fail("systemctl is-active container@triggered.service")
  '';
})

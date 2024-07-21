import ./make-test-python.nix ({ lib, ... }: {
  name = "containers-require-bind-mounts";
  meta.maintainers = with lib.maintainers; [ kira-bruneau ];

  nodes.machine = {
    containers.require-bind-mounts = {
      bindMounts = { "/srv/data" = {}; };
      config = {};
    };

    virtualisation.fileSystems = {
      "/srv/data" = {
        fsType = "tmpfs";
        options = [ "noauto" ];
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("default.target")

    assert "require-bind-mounts" in machine.succeed("nixos-container list")
    assert "down" in machine.succeed("nixos-container status require-bind-mounts")
    assert "inactive" in machine.fail("systemctl is-active srv-data.mount")

    with subtest("bind mount host paths must be mounted to run container"):
      machine.succeed("nixos-container start require-bind-mounts")
      assert "up" in machine.succeed("nixos-container status require-bind-mounts")
      assert "active" in machine.succeed("systemctl status srv-data.mount")

      machine.succeed("systemctl stop srv-data.mount")
      assert "down" in machine.succeed("nixos-container status require-bind-mounts")
      assert "inactive" in machine.fail("systemctl is-active srv-data.mount")
    '';
})

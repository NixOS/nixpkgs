{ lib, ... }:
{
  name = "lustrate";

  nodes.machine = {
    boot.initrd.systemd = {
      enable = true;
      lustrate.enable = true;
    };
  };

  testScript = ''
    machine.start(allow_reboot=True)

    # Lustrate if /etc/NIXOS_LUSTRATE exists
    machine.succeed("touch /foo")
    machine.succeed("touch /etc/NIXOS_LUSTRATE")
    machine.reboot()
    machine.succeed("ls -l /old-root")
    machine.fail("ls -l /foo")

    # That should have also deleted /etc/NIXOS_LUSTRATE, so don't lustrate again
    machine.succeed("touch /bar")
    machine.reboot()
    machine.succeed("ls -l /bar")
  '';
}

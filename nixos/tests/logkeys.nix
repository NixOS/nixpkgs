{ lib, ... }:
{
  name = "logkeys";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes.machine = {
    imports = [ ./common/user-account.nix ];

    services.getty.autologinUser = "alice";

    services.logkeys = {
      enable = true;
      device = "virtio-kbd";
    };

    # logkeys doesn't support specifying a device in `by-path`.
    # In order not to make the test dependend on the ordering of the input event devices,
    # we'll create a custom symlink before starting the service.
    systemd.services.logkeys.preStart = ''
      ln -sf /dev/input/by-path/pci-*-event-kbd /dev/input/virtio-kbd
    '';
  };

  testScript = ''
    machine.wait_for_unit("getty@tty1.service")
    machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
    machine.wait_for_unit("logkeys.service")

    machine.send_chars("hello world\n")
    machine.wait_until_succeeds("grep 'hello world' /var/log/logkeys.log")
  '';
}

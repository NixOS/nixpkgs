{
  name = "supplicant";
  meta.maintainers = [ ];

  nodes.machine = {
    networking.supplicant.LAN = {
      driver = "wired";
      extraConf = "ap_scan=0";
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("supplicant-lan@eth1.service")
    machine.fail("test -e /etc/systemd/system/multi-user.target.wants/supplicant-lan@.service")

    # The instance is reachable only through the udev rules, and udev does not
    # replay "add" for an interface that already exists. Re-running the trigger
    # has to bring it back, or a rebuild would leave it stopped until a reboot.
    machine.succeed("systemctl stop supplicant-lan@eth1.service")
    machine.succeed("systemctl restart supplicant-udev-trigger.service")
    machine.wait_for_unit("supplicant-lan@eth1.service")
  '';
}

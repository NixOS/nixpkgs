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
  '';
}

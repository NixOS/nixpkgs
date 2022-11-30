# This test makes sure that lxd supports creating an OVS bridge.

import ./make-test-python.nix ({ pkgs, lib, ...} :

{
  name = "lxd-ovs";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ patryk27 ];
  };

  nodes.machine = { lib, ... }: {
    virtualisation = {
      lxd.enable = true;
      lxd.ovsSupport = true;
      vswitch.enable = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("sockets.target")
    machine.wait_for_unit("lxd.service")
    machine.wait_for_file("/var/lib/lxd/unix.socket")

    # It takes additional second for lxd to settle
    machine.sleep(1)

    with subtest("Open vSwitch bridge can be created"):
        machine.succeed("lxc network create ovsbr0 --type=bridge bridge.driver=openvswitch")

    machine.execute("lxc network list")
  '';
})

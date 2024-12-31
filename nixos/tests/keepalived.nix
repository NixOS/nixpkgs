import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "keepalived";
  meta.maintainers = [ lib.maintainers.raitobezarius ];

  nodes = {
    node1 = { pkgs, ... }: {
      services.keepalived.enable = true;
      services.keepalived.openFirewall = true;
      services.keepalived.vrrpInstances.test = {
        interface = "eth1";
        state = "MASTER";
        priority = 50;
        virtualIps = [{ addr = "192.168.1.200"; }];
        virtualRouterId = 1;
      };
      environment.systemPackages = [ pkgs.tcpdump ];
      specialisation = {
        config-reload.configuration = {
          services.keepalived.vrrpInstances.test.virtualIps = [{ addr = "192.168.1.201"; }];
        };
          config-restart.configuration = {
          services.keepalived.snmp.enable = true;
          services.keepalived.vrrpInstances.test.virtualIps = [{ addr = "192.168.1.202"; }];
        };
      };
    };
    node2 = { pkgs, ... }: {
      services.keepalived.enable = true;
      services.keepalived.openFirewall = true;
      services.keepalived.vrrpInstances.test = {
        interface = "eth1";
        state = "MASTER";
        priority = 100;
        virtualIps = [{ addr = "192.168.1.200"; }];
        virtualRouterId = 1;
      };
      environment.systemPackages = [ pkgs.tcpdump ];
    };
  };

  testScript = { nodes, ... }:
    let
      reloadSystem = "${nodes.node1.system.build.toplevel}/specialisation/config-reload";
      restartSystem = "${nodes.node1.system.build.toplevel}/specialisation/config-restart";
    in
    ''
    # wait for boot time delay to pass
    for node in [node1, node2]:
        node.wait_until_succeeds(
            "systemctl show -p LastTriggerUSecMonotonic keepalived-boot-delay.timer | grep -vq 'LastTriggerUSecMonotonic=0'"
        )
        node.wait_for_unit("keepalived")
    node2.wait_until_succeeds("ip addr show dev eth1 | grep -q 192.168.1.200")
    node1.fail("ip addr show dev eth1 | grep -q 192.168.1.200")
    node1.succeed("ping -c1 192.168.1.200")

    with subtest("failover"):
      node2.block()
      node1.wait_until_succeeds("ip addr show dev eth1 | grep -q 192.168.1.200")
      node2.unblock()
      node1.wait_until_fails("ip addr show dev eth1 | grep -q 192.168.1.200")

    with subtest("reload config"):
      node1.fail("ip addr show dev eth1 | grep -q 192.168.1.201")
      node1.succeed("${reloadSystem}/bin/switch-to-configuration test >&2")
      node1.wait_until_succeeds("ip addr show dev eth1 | grep -q 192.168.1.201")
      node1.fail("journalctl -u keepalived | grep -q Stopped")
      node1.succeed("journalctl -u keepalived | grep -q Reloaded")

    with subtest("restart config"):
      node1.fail("ip addr show dev eth1 | grep -q 192.168.1.202")
      node1.succeed("${restartSystem}/bin/switch-to-configuration test >&2")
      node1.wait_until_succeeds("ip addr show dev eth1 | grep -q 192.168.1.202")
      node1.succeed("[ $(journalctl -b -u keepalived | grep -c Reloaded) == 1 ]")
      node1.succeed("[ $(journalctl -b -u keepalived | grep -c Stopped) == 1 ]")
      node1.succeed("[ $(journalctl -b -u keepalived | grep -c Started) == 2 ]")
  '';
})

import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "keepalived";
    meta.maintainers = [ lib.maintainers.raitobezarius ];

    nodes = {
      node1 =
        { pkgs, ... }:
        {
          services.keepalived.enable = true;
          services.keepalived.openFirewall = true;
          services.keepalived.vrrpInstances.test = {
            interface = "eth1";
            state = "MASTER";
            priority = 50;
            virtualIps = [ { addr = "192.168.1.200"; } ];
            virtualRouterId = 1;
          };
          environment.systemPackages = [ pkgs.tcpdump ];
        };
      node2 =
        { pkgs, ... }:
        {
          services.keepalived.enable = true;
          services.keepalived.openFirewall = true;
          services.keepalived.vrrpInstances.test = {
            interface = "eth1";
            state = "MASTER";
            priority = 100;
            virtualIps = [ { addr = "192.168.1.200"; } ];
            virtualRouterId = 1;
          };
          environment.systemPackages = [ pkgs.tcpdump ];
        };
    };

    testScript = ''
      # wait for boot time delay to pass
      for node in [node1, node2]:
          node.wait_until_succeeds(
              "systemctl show -p LastTriggerUSecMonotonic keepalived-boot-delay.timer | grep -vq 'LastTriggerUSecMonotonic=0'"
          )
          node.wait_for_unit("keepalived")
      node2.wait_until_succeeds("ip addr show dev eth1 | grep -q 192.168.1.200")
      node1.fail("ip addr show dev eth1 | grep -q 192.168.1.200")
      node1.succeed("ping -c1 192.168.1.200")
    '';
  }
)

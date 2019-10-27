# Test for NixOS' container support.

import ./make-test.nix ({ pkgs, ...} : {
  name = "containers-bridge";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ kampfschlaefer ];
  };

  machine =
    { pkgs, ... }:
    { imports = [ ../modules/installer/cd-dvd/channel.nix ];
      virtualisation.writableStore = true;
      virtualisation.memorySize = 768;
      virtualisation.vlans = [];

      networking.useDHCP = false;
      networking.bridges = {
        br0 = {
          interfaces = [];
        };
        br1 = { interfaces = []; };
      };
      networking.interfaces = {
        br0 = {
          ipv4.addresses = [{ address = "192.168.0.1"; prefixLength = 24; }];
          ipv6.addresses = [{ address = "fc00::1"; prefixLength = 7; }];
        };
        br1 = {
          ipv4.addresses = [{ address = "192.168.1.1"; prefixLength = 24; }];
        };
      };

      containers.webserver =
        {
          autoStart = true;
          privateNetwork = true;
          hostBridge = "br0";
          localAddress = "192.168.0.100/24";
          localAddress6 = "fc00::2/7";
          extraVeths = {
            veth1 = { hostBridge = "br1"; localAddress = "192.168.1.100/24"; };
            veth2 = { hostAddress = "192.168.2.1"; localAddress = "192.168.2.100"; };
          };
          config =
            {
              networking.firewall.allowedTCPPorts = [ 80 ];
            };
        };

      virtualisation.pathsInNixDB = [ pkgs.stdenv ];
    };

  testScript =
    ''
      $machine->waitForUnit("default.target");
      $machine->succeed("nixos-container list") =~ /webserver/ or die;

      # Status of the webserver container.
      $machine->succeed("nixos-container status webserver") =~ /up/ or die;

      # Debug
      #$machine->succeed("nixos-container run webserver -- ip link >&2");

      # Ensure that the veths are inside the container
      $machine->succeed("nixos-container run webserver -- ip link show veth1") =~ /state UP/ or die;
      $machine->succeed("nixos-container run webserver -- ip link show veth2") =~ /state UP/ or die;

      # Debug
      #$machine->succeed("ip link >&2");

      # Ensure the presence of the extra veths
      $machine->succeed("ip link show veth1") =~ /state UP/ or die;
      $machine->succeed("ip link show veth2") =~ /state UP/ or die;

      # Ensure the veth1 is part of br1 on the host
      $machine->succeed("ip link show veth1") =~ /master br1/ or die;

      # Debug
      #$machine->succeed("ip -4 a >&2");
      #$machine->succeed("ip -4 r >&2");
      #$machine->succeed("nixos-container run webserver -- ip link >&2");
      #$machine->succeed("nixos-container run webserver -- ip -4 a >&2");
      #$machine->succeed("nixos-container run webserver -- ip -4 r >&2");

      # Ping on main veth
      $machine->succeed("ping -n -c 1 192.168.0.100");
      $machine->succeed("ping -n -c 1 fc00::2");

      # Ping on the first extra veth
      $machine->succeed("ping -n -c 1 192.168.1.100 >&2");

      # Ping on the second extra veth
      $machine->succeed("ping -n -c 1 192.168.2.100 >&2");

      # Stop the container.
      $machine->succeed("nixos-container stop webserver");
      $machine->fail("ping -n -c 1 192.168.1.100 >&2");
      $machine->fail("ping -n -c 1 192.168.2.100 >&2");

      # Destroying a declarative container should fail.
      $machine->fail("nixos-container destroy webserver");
    '';
})

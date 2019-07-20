# Test for NixOS' container support.

let
  hostIp = "192.168.0.1";
  containerIp = "192.168.0.100/24";
  hostIp6 = "fc00::1";
  containerIp6 = "fc00::2/7";
in

import ./make-test.nix ({ pkgs, ...} : {
  name = "containers-bridge";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aristid aszlig eelco kampfschlaefer ];
  };

  machine =
    { pkgs, ... }:
    { imports = [ ../modules/installer/cd-dvd/channel.nix ];
      virtualisation.writableStore = true;
      virtualisation.memorySize = 768;

      networking.bridges = {
        br0 = {
          interfaces = [];
        };
      };
      networking.interfaces = {
        br0 = {
          ipv4.addresses = [{ address = hostIp; prefixLength = 24; }];
          ipv6.addresses = [{ address = hostIp6; prefixLength = 7; }];
        };
      };

      containers.webserver =
        {
          autoStart = true;
          privateNetwork = true;
          hostBridge = "br0";
          localAddress = containerIp;
          localAddress6 = containerIp6;
          config =
            { services.httpd.enable = true;
              services.httpd.adminAddr = "foo@example.org";
              networking.firewall.allowedTCPPorts = [ 80 ];
            };
        };

      containers.web-noip =
        {
          autoStart = true;
          privateNetwork = true;
          hostBridge = "br0";
          config =
            { services.httpd.enable = true;
              services.httpd.adminAddr = "foo@example.org";
              networking.firewall.allowedTCPPorts = [ 80 ];
            };
        };


      virtualisation.pathsInNixDB = [ pkgs.stdenv ];
    };

  testScript =
    ''
      $machine->waitForUnit("default.target");
      $machine->succeed("nixos-container list") =~ /webserver/ or die;

      # Start the webserver container.
      $machine->succeed("nixos-container status webserver") =~ /up/ or die;

      # Check if bridges exist inside containers
      $machine->succeed("nixos-container run webserver -- ip link show eth0");
      $machine->succeed("nixos-container run web-noip -- ip link show eth0");

      "${containerIp}" =~ /([^\/]+)\/([0-9+])/;
      my $ip = $1;
      chomp $ip;
      $machine->succeed("ping -n -c 1 $ip");
      $machine->succeed("curl --fail http://$ip/ > /dev/null");

      "${containerIp6}" =~ /([^\/]+)\/([0-9+])/;
      my $ip6 = $1;
      chomp $ip6;
      $machine->succeed("ping -n -c 1 $ip6");
      $machine->succeed("curl --fail http://[$ip6]/ > /dev/null");

      # Check that nixos-container show-ip works in case of an ipv4 address with
      # subnetmask in CIDR notation.
      my $result = $machine->succeed("nixos-container show-ip webserver");
      chomp $result;
      $result eq $ip or die;

      # Stop the container.
      $machine->succeed("nixos-container stop webserver");
      $machine->fail("curl --fail --connect-timeout 2 http://$ip/ > /dev/null");
      $machine->fail("curl --fail --connect-timeout 2 http://[$ip6]/ > /dev/null");

      # Destroying a declarative container should fail.
      $machine->fail("nixos-container destroy webserver");
    '';

})

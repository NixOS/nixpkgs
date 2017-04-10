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
    maintainers = [ aristid aszlig eelco chaoflow ];
  };

  machine =
    { config, pkgs, ... }:
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
          ip4 = [{ address = hostIp; prefixLength = 24; }];
          ip6 = [{ address = hostIp6; prefixLength = 7; }];
        };
      };

      containers.webserver =
        { privateNetwork = true;
          hostBridge = "br0";
          localAddress = containerIp;
          localAddress6 = containerIp6;
          config =
            { services.httpd.enable = true;
              services.httpd.adminAddr = "foo@example.org";
              networking.firewall.allowedTCPPorts = [ 80 ];
              networking.firewall.allowPing = true;
            };
        };

      virtualisation.pathsInNixDB = [ pkgs.stdenv ];
    };

  testScript =
    ''
      $machine->waitForUnit("default.target");
      $machine->succeed("nixos-container list") =~ /webserver/ or die;

      # Start the webserver container.
      $machine->succeed("nixos-container start webserver");

      # wait two seconds for the container to start and the network to be up
      sleep 2;

      # Since "start" returns after the container has reached
      # multi-user.target, we should now be able to access it.
      "${containerIp}" =~ /([^\/]+)\/([0-9+])/;
      my $ip = $1;
      chomp $ip;
      $machine->succeed("ping -n -c 1 $ip");
      $machine->succeed("curl --fail http://$ip/ > /dev/null");

      "${containerIp6}" =~ /([^\/]+)\/([0-9+])/;
      my $ip6 = $1;
      chomp $ip6;
      $machine->succeed("ping6 -n -c 1 $ip6");
      $machine->succeed("curl --fail http://[$ip6]/ > /dev/null");

      # Stop the container.
      $machine->succeed("nixos-container stop webserver");
      $machine->fail("curl --fail --connect-timeout 2 http://$ip/ > /dev/null");
      $machine->fail("curl --fail --connect-timeout 2 http://[$ip6]/ > /dev/null");

      # Destroying a declarative container should fail.
      $machine->fail("nixos-container destroy webserver");
    '';

})

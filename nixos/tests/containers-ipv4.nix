# Test for NixOS' container support.

import ./make-test.nix ({ pkgs, ...} : {
  name = "containers-ipv4";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aristid aszlig eelco chaoflow ];
  };

  machine =
    { config, pkgs, ... }:
    { imports = [ ../modules/installer/cd-dvd/channel.nix ];
      virtualisation.writableStore = true;
      virtualisation.memorySize = 768;

      containers.webserver =
        { privateNetwork = true;
          hostAddress = "10.231.136.1";
          localAddress = "10.231.136.2";
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
      $machine->succeed("nixos-container list") =~ /webserver/ or die;

      # Start the webserver container.
      $machine->succeed("nixos-container start webserver");

      # wait two seconds for the container to start and the network to be up
      sleep 2;

      # Since "start" returns after the container has reached
      # multi-user.target, we should now be able to access it.
      my $ip = $machine->succeed("nixos-container show-ip webserver");
      chomp $ip;
      $machine->succeed("ping -n -c1 $ip");
      $machine->succeed("curl --fail http://$ip/ > /dev/null");

      # Stop the container.
      $machine->succeed("nixos-container stop webserver");
      $machine->fail("curl --fail --connect-timeout 2 http://$ip/ > /dev/null");

      # Destroying a declarative container should fail.
      $machine->fail("nixos-container destroy webserver");
    '';

})

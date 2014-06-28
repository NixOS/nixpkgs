# Test for NixOS' container support.

import ./make-test.nix {
  name = "containers";

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

      # Since "start" returns after the container has reached
      # multi-user.target, we should now be able to access it.
      my $ip = $machine->succeed("nixos-container show-ip webserver");
      chomp $ip;
      $machine->succeed("ping -c1 $ip");
      $machine->succeed("curl --fail http://$ip/ > /dev/null");

      # Stop the container.
      $machine->succeed("nixos-container stop webserver");
      $machine->fail("curl --fail --connect-timeout 2 http://$ip/ > /dev/null");

      # Make sure we have a NixOS tree (required by ‘nixos-container create’).
      $machine->succeed("nix-env -qa -A nixos.pkgs.hello >&2");

      # Create some containers imperatively.
      my $id1 = $machine->succeed("nixos-container create foo --ensure-unique-name");
      chomp $id1;
      $machine->log("created container $id1");

      my $id2 = $machine->succeed("nixos-container create foo --ensure-unique-name");
      chomp $id2;
      $machine->log("created container $id2");

      die if $id1 eq $id2;

      my $ip1 = $machine->succeed("nixos-container show-ip $id1");
      chomp $ip1;
      my $ip2 = $machine->succeed("nixos-container show-ip $id2");
      chomp $ip2;
      die if $ip1 eq $ip2;

      # Start one of them.
      $machine->succeed("nixos-container start $id1");

      # Execute commands via the root shell.
      $machine->succeed("nixos-container run $id1 -- uname") =~ /Linux/ or die;
      $machine->succeed("nixos-container set-root-password $id1 foobar");

      # Destroy the containers.
      $machine->succeed("nixos-container destroy $id1");
      $machine->succeed("nixos-container destroy $id2");

      # Destroying a declarative container should fail.
      $machine->fail("nixos-container destroy webserver");
    '';

}

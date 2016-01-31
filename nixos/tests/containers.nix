# Test for NixOS' container support.

import ./make-test.nix ({ pkgs, ...} : {
  name = "containers";
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

      # Make sure we have a NixOS tree (required by ‘nixos-container create’).
      $machine->succeed("PAGER=cat nix-env -qa -A nixos.hello >&2");

      # Create some containers imperatively.
      my $id1 = $machine->succeed("nixos-container create foo --ensure-unique-name");
      chomp $id1;
      $machine->log("created container $id1");

      my $id2 = $machine->succeed("nixos-container create foo --ensure-unique-name");
      chomp $id2;
      $machine->log("created container $id2");

      die if $id1 eq $id2;

      # Put the root of $id2 into a bind mount.
      $machine->succeed(
        "mv /var/lib/containers/$id2 /id2-bindmount",
        "mount --bind /id2-bindmount /var/lib/containers/$id1"
      );

      my $ip1 = $machine->succeed("nixos-container show-ip $id1");
      chomp $ip1;
      my $ip2 = $machine->succeed("nixos-container show-ip $id2");
      chomp $ip2;
      die if $ip1 eq $ip2;

      # Create a directory and a file we can later check if it still exists
      # after destruction of the container.
      $machine->succeed(
        "mkdir /nested-bindmount",
        "echo important data > /nested-bindmount/dummy",
      );

      # Create a directory with a dummy file and bind-mount it into both
      # containers.
      foreach ($id1, $id2) {
        my $importantPath = "/var/lib/containers/$_/very/important/data";
        $machine->succeed(
          "mkdir -p $importantPath",
          "mount --bind /nested-bindmount $importantPath"
        );
      }

      # Start one of them.
      $machine->succeed("nixos-container start $id1");

      # Execute commands via the root shell.
      $machine->succeed("nixos-container run $id1 -- uname") =~ /Linux/ or die;

      # Stop and start (regression test for #4989)
      $machine->succeed("nixos-container stop $id1");
      $machine->succeed("nixos-container start $id1");

      # Execute commands via the root shell.
      $machine->succeed("nixos-container run $id1 -- uname") =~ /Linux/ or die;

      # Destroy the containers.
      $machine->succeed("nixos-container destroy $id1");
      $machine->succeed("nixos-container destroy $id2");

      $machine->succeed(
        # Check whether destruction of any container has killed important data
        "grep -qF 'important data' /nested-bindmount/dummy",
        # Ensure that the container path is gone
        "test ! -e /var/lib/containers/$id1"
      );

      # Destroying a declarative container should fail.
      $machine->fail("nixos-container destroy webserver");
    '';

})

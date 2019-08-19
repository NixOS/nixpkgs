# Test for NixOS' container support.

import ./make-test.nix ({ pkgs, ...} : {
  name = "containers-ephemeral";

  machine = { pkgs, ... }: {
    virtualisation.memorySize = 768;
    virtualisation.writableStore = true;

    containers.webserver = {
      ephemeral = true;
      privateNetwork = true;
      hostAddress = "10.231.136.1";
      localAddress = "10.231.136.2";
      config = {
        services.nginx = {
          enable = true;
          virtualHosts.localhost = {
            root = (pkgs.runCommand "localhost" {} ''
              mkdir "$out"
              echo hello world > "$out/index.html"
            '');
          };
        };
        networking.firewall.allowedTCPPorts = [ 80 ];
      };
    };
  };

  testScript = ''
    $machine->succeed("nixos-container list") =~ /webserver/ or die;

    # Start the webserver container.
    $machine->succeed("nixos-container start webserver");

    # Check that container got its own root folder
    $machine->succeed("ls /run/containers/webserver");

    # Check that container persistent directory is not created
    $machine->fail("ls /var/lib/containers/webserver");

    # Since "start" returns after the container has reached
    # multi-user.target, we should now be able to access it.
    my $ip = $machine->succeed("nixos-container show-ip webserver");
    chomp $ip;
    $machine->succeed("ping -n -c1 $ip");
    $machine->succeed("curl --fail http://$ip/ > /dev/null");

    # Stop the container.
    $machine->succeed("nixos-container stop webserver");
    $machine->fail("curl --fail --connect-timeout 2 http://$ip/ > /dev/null");

    # Check that container's root folder was removed
    $machine->fail("ls /run/containers/webserver");
  '';
})

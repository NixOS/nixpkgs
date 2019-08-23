# Test for NixOS' container support.

import ./make-test.nix ({ pkgs, ...} : {
  name = "containers-unprivileged";

  machine = { pkgs, ... }: {
    virtualisation.memorySize = 768;
    virtualisation.writableStore = true;

    containers.webserver = {
      unprivileged = true;
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

    my $ip = $machine->succeed("nixos-container show-ip webserver");
    chomp $ip;
    $machine->succeed("ping -n -c1 $ip");

    # Check that container root folder is owned by a new private user
    $machine->succeed('test $(stat -c "%U" /var/lib/containers/webserver) == "vu-webserver-0"');

    # Check that webserver is working before reload
    $machine->succeed("curl --fail http://$ip/ > /dev/null");

    # Reload container
    $machine->succeed('systemctl reload container@webserver');

    # Check that webserver is working after reload
    $machine->succeed("curl --fail http://$ip/ > /dev/null");

    # Stop the container.
    $machine->succeed("nixos-container stop webserver");
    $machine->fail("curl --fail --connect-timeout 2 http://$ip/ > /dev/null");
  '';
})

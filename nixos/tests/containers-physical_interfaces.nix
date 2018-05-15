
import ./make-test.nix ({ pkgs, ...} : {
  name = "containers-physical_interfaces";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ kampfschlaefer ];
  };

  nodes = {
    server = { config, pkgs, ... }:
      {
        virtualisation.memorySize = 256;
        virtualisation.vlans = [ 1 ];

        containers.server = {
          privateNetwork = true;
          interfaces = [ "eth1" ];

          config = {
            networking.interfaces.eth1.ipv4.addresses = [
              { address = "10.10.0.1"; prefixLength = 24; }
            ];
            networking.firewall.enable = false;
          };
        };
      };
    bridged = { config, pkgs, ... }: {
      virtualisation.memorySize = 128;
      virtualisation.vlans = [ 1 ];

      containers.bridged = {
        privateNetwork = true;
        interfaces = [ "eth1" ];

        config = {
          networking.bridges.br0.interfaces = [ "eth1" ];
          networking.interfaces.br0.ipv4.addresses = [
            { address = "10.10.0.2"; prefixLength = 24; }
          ];
          networking.firewall.enable = false;
        };
      };
    };

    bonded = { config, pkgs, ... }: {
      virtualisation.memorySize = 128;
      virtualisation.vlans = [ 1 ];

      containers.bonded = {
        privateNetwork = true;
        interfaces = [ "eth1" ];

        config = {
          networking.bonds.bond0 = {
            interfaces = [ "eth1" ];
            driverOptions.mode = "active-backup";
          };
          networking.interfaces.bond0.ipv4.addresses = [
            { address = "10.10.0.3"; prefixLength = 24; }
          ];
          networking.firewall.enable = false;
        };
      };
    };

    bridgedbond = { config, pkgs, ... }: {
      virtualisation.memorySize = 128;
      virtualisation.vlans = [ 1 ];

      containers.bridgedbond = {
        privateNetwork = true;
        interfaces = [ "eth1" ];

        config = {
          networking.bonds.bond0 = {
            interfaces = [ "eth1" ];
            driverOptions.mode = "active-backup";
          };
          networking.bridges.br0.interfaces = [ "bond0" ];
          networking.interfaces.br0.ipv4.addresses = [
            { address = "10.10.0.4"; prefixLength = 24; }
          ];
          networking.firewall.enable = false;
        };
      };
    };
  };

  testScript = ''
    startAll;

    subtest "prepare server", sub {
      $server->waitForUnit("default.target");
      $server->succeed("ip link show dev eth1 >&2");
    };

    subtest "simple physical interface", sub {
      $server->succeed("nixos-container start server");
      $server->waitForUnit("container\@server");
      $server->succeed("systemctl -M server list-dependencies network-addresses-eth1.service >&2");

      # The other tests will ping this container on its ip. Here we just check
      # that the device is present in the container.
      $server->succeed("nixos-container run server -- ip a show dev eth1 >&2");
    };

    subtest "physical device in bridge in container", sub {
      $bridged->waitForUnit("default.target");
      $bridged->succeed("nixos-container start bridged");
      $bridged->waitForUnit("container\@bridged");
      $bridged->succeed("systemctl -M bridged list-dependencies network-addresses-br0.service >&2");
      $bridged->succeed("systemctl -M bridged status -n 30 -l network-addresses-br0.service");
      $bridged->succeed("nixos-container run bridged -- ping -w 10 -c 1 -n 10.10.0.1");
    };

    subtest "physical device in bond in container", sub {
      $bonded->waitForUnit("default.target");
      $bonded->succeed("nixos-container start bonded");
      $bonded->waitForUnit("container\@bonded");
      $bonded->succeed("systemctl -M bonded list-dependencies network-addresses-bond0 >&2");
      $bonded->succeed("systemctl -M bonded status -n 30 -l network-addresses-bond0 >&2");
      $bonded->succeed("nixos-container run bonded -- ping -w 10 -c 1 -n 10.10.0.1");
    };

    subtest "physical device in bond in bridge in container", sub {
      $bridgedbond->waitForUnit("default.target");
      $bridgedbond->succeed("nixos-container start bridgedbond");
      $bridgedbond->waitForUnit("container\@bridgedbond");
      $bridgedbond->succeed("systemctl -M bridgedbond list-dependencies network-addresses-br0.service >&2");
      $bridgedbond->succeed("systemctl -M bridgedbond status -n 30 -l network-addresses-br0.service");
      $bridgedbond->succeed("nixos-container run bridgedbond -- ping -w 10 -c 1 -n 10.10.0.1");
    };
  '';
})


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
            networking.interfaces.eth1 = {
              ip4 = [ { address = "10.10.0.1"; prefixLength = 24; } ];
            };
            networking.firewall.enable = false;
          };
        };
      };
    client = { config, pkgs, ... }: {
      virtualisation.memorySize = 256;
      virtualisation.vlans = [ 1 ];

      containers.client = {
        privateNetwork = true;
        interfaces = [ "eth1" ];

        config = {
          networking.bridges.br0.interfaces = [ "eth1" ];
          networking.interfaces.br0 = {
            ip4 = [ { address = "10.10.0.2"; prefixLength = 24; } ];
          };
          networking.firewall.enable = false;
        };
      };
    };
  };

  testScript = ''
    startAll;

    $server->waitForUnit("default.target");
    $server->execute("ip link >&2");

    $server->succeed("ip link show dev eth1 >&2");

    $server->succeed("nixos-container start server");
    $server->waitForUnit("container\@server");
    $server->succeed("systemctl -M server list-dependencies network-addresses-eth1.service >&2");

    $server->succeed("nixos-container run server -- ip a show dev eth1 >&2");

    $client->waitForUnit("default.target");
    $client->succeed("nixos-container start client");
    $client->waitForUnit("container\@client");
    $client->succeed("systemctl -M client list-dependencies network-addresses-br0.service >&2");
    $client->succeed("systemctl -M client status -n 30 -l network-addresses-br0.service");
    $client->succeed("nixos-container run client -- ping -w 10 -c 1 -n 10.10.0.1");
  '';
})

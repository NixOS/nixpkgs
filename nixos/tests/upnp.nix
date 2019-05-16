# This tests whether UPnP port mappings can be created using Miniupnpd
# and Miniupnpc.
# It runs a Miniupnpd service on one machine, and verifies
# a client can indeed create a port mapping using Miniupnpc. If
# this succeeds an external client will try to connect to the port
# mapping.

import ./make-test.nix ({ pkgs, ... }:

let
  internalRouterAddress = "192.168.3.1";
  internalClient1Address = "192.168.3.2";
  externalRouterAddress = "80.100.100.1";
  externalClient2Address = "80.100.100.2";
in
{
  name = "upnp";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bobvanderlinden ];
  };

  nodes =
    {
      router =
        { pkgs, nodes, ... }:
        { virtualisation.vlans = [ 1 2 ];
          networking.nat.enable = true;
          networking.nat.internalInterfaces = [ "eth2" ];
          networking.nat.externalInterface = "eth1";
          networking.firewall.enable = true;
          networking.firewall.trustedInterfaces = [ "eth2" ];
          networking.interfaces.eth1.ipv4.addresses = [
            { address = externalRouterAddress; prefixLength = 24; }
          ];
          networking.interfaces.eth2.ipv4.addresses = [
            { address = internalRouterAddress; prefixLength = 24; }
          ];
          services.miniupnpd = {
            enable = true;
            externalInterface = "eth1";
            internalIPs = [ "eth2" ];
            appendConfig = ''
              ext_ip=${externalRouterAddress}
            '';
          };
        };

      client1 =
        { pkgs, nodes, ... }:
        { environment.systemPackages = [ pkgs.miniupnpc_2 pkgs.netcat ];
          virtualisation.vlans = [ 2 ];
          networking.defaultGateway = internalRouterAddress;
          networking.interfaces.eth1.ipv4.addresses = [
            { address = internalClient1Address; prefixLength = 24; }
          ];
          networking.firewall.enable = false;

          services.httpd.enable = true;
          services.httpd.listen = [{ ip = "*"; port = 9000; }];
          services.httpd.adminAddr = "foo@example.org";
          services.httpd.documentRoot = "/tmp";
        };

      client2 =
        { pkgs, ... }:
        { environment.systemPackages = [ pkgs.miniupnpc_2 ];
          virtualisation.vlans = [ 1 ];
          networking.interfaces.eth1.ipv4.addresses = [
            { address = externalClient2Address; prefixLength = 24; }
          ];
          networking.firewall.enable = false;
        };
    };

  testScript =
    { nodes, ... }:
    ''
      startAll;

      # Wait for network and miniupnpd.
      $router->waitForUnit("network-online.target");
      # $router->waitForUnit("nat");
      $router->waitForUnit("firewall.service");
      $router->waitForUnit("miniupnpd");

      $client1->waitForUnit("network-online.target");

      $client1->succeed("upnpc -a ${internalClient1Address} 9000 9000 TCP");

      $client1->waitForUnit("httpd");
      $client2->waitUntilSucceeds("curl http://${externalRouterAddress}:9000/");
    '';

})

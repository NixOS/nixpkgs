# This tests whether UPnP and NAT-PMP port mappings can be created
# using Miniupnpd, Miniupnpc and Libnatpmp.
#
# It runs a Miniupnpd service on one machine, and verifies
# a machine hosting a server can indeed create and remove
# port mappings using Miniupnpc and Libnatpmp.
#
# An external client will try to connect via the port
# mapping both when opened and closed.

import ./make-test-python.nix ({ pkgs, ... }:

let
  internalRouterAddress = "192.168.3.1";
  internalServerAddress = "192.168.3.2";
  externalRouterAddress = "80.100.100.1";
  externalClientAddress = "80.100.100.2";
in
{
  name = "upnp";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ bobvanderlinden ];
  };

  nodes =
    {
      router =
        # NAT router, forwarding between the server and the client
        { pkgs, ... }:
        { virtualisation.vlans = [ 1 2 ];
          networking.nat.enable = true;
          networking.nat.internalInterfaces = [ "eth2" ];
          networking.nat.externalInterface = "eth1";
          networking.firewall.enable = true;
          networking.firewall.trustedInterfaces = [ "eth2" ];
          networking.firewall.rejectPackets = true;
          networking.interfaces.eth1.ipv4.addresses = [
            { address = externalRouterAddress; prefixLength = 24; }
          ];
          networking.interfaces.eth2.ipv4.addresses = [
            { address = internalRouterAddress; prefixLength = 24; }
          ];
          services.miniupnpd = {
            enable = true;
            upnp = true;
            natpmp = true;
            externalInterface = "eth1";
            internalIPs = [ internalRouterAddress ];
            appendConfig = ''
              ext_ip=${externalRouterAddress}
            '';
          };
        };

      server =
        # Internal server, hosted behind the NAT router (inside)
        { pkgs, ... }:
        { virtualisation.vlans = [ 2 ];
          environment.systemPackages = [ pkgs.miniupnpc_2 pkgs.libnatpmp ];
          networking.defaultGateway = internalRouterAddress;
          networking.interfaces.eth1.ipv4.addresses = [
            { address = internalServerAddress; prefixLength = 24; }
          ];
          networking.firewall.enable = false;

          services.httpd.enable = true;
          services.httpd.virtualHosts.localhost = {
            listen = [
              { ip = "*"; port = 9001; }
              { ip = "*"; port = 9002; }
            ];
            adminAddr = "admin@example.org";
          };
        };

      client =
        # External client, connecting from a network such as the Internet (outside)
        { pkgs, ... }:
        { virtualisation.vlans = [ 1 ];
          networking.interfaces.eth1.ipv4.addresses = [
            { address = externalClientAddress; prefixLength = 24; }
          ];
        };
    };

  testScript =
    ''
      start_all()

      # Wait for router network and miniupnpd
      router.wait_for_unit("network-online.target")
      router.wait_for_unit("firewall.service")
      router.wait_for_unit("miniupnpd")

      # Wait for external server
      server.wait_for_unit("network-online.target")
      server.wait_for_unit("httpd")

      # Wait for internal client network and ensure the server is not yet reachable
      client.wait_for_unit("network-online.target")
      client.fail("curl --fail http://${externalRouterAddress}:9001/")
      client.fail("curl --fail http://${externalRouterAddress}:9002/")

      # uPnP open
      server.succeed("upnpc -a ${internalServerAddress} 9001 9001 TCP")
      client.wait_until_succeeds("curl http://${externalRouterAddress}:9001/")

      # uPnP close
      server.succeed("upnpc -d 9001 TCP ${internalServerAddress}")
      client.fail("curl --fail http://${externalRouterAddress}:9001/")

      # NAT-PMP open
      server.succeed("natpmpc -g ${internalRouterAddress} -a 9002 9002 TCP 3600")
      client.wait_until_succeeds("curl http://${externalRouterAddress}:9002/")

      # NAT-PMP close
      server.succeed("natpmpc -g ${internalRouterAddress} -a 9002 9002 TCP 0")
      client.fail("curl --fail http://${externalRouterAddress}:9002/")
    '';
})

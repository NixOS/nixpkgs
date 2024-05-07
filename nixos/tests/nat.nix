# This is a distributed test of the Network Address Translation involving a topology
# with a router inbetween three separate virtual networks:
# - "external" -- i.e. the internet,
# - "internal" -- i.e. an office LAN,
# - "uninvolved" - i.e. an uninvolved technical LAN, _not_ mentioned anywhere in the
#   router's NAT configuration.
#
# This test puts one server on each of those networks and its primary goal is to ensure that:
# - server in internal network can reach server on the external network,
# - server in the external network cannot reach the server in the internal network,
# - server on the "uninvolved" network remains unaffected by the NAT (cannot be reached externally)
# - port forwarding functionaly behaves correctly

import ./make-test-python.nix ({ pkgs, lib, withFirewall ? false, nftables ? false, ... }:
  let
    unit = if nftables then "nftables" else (if withFirewall then "firewall" else "nat");

    routerAlternativeExternalIp = "192.168.3.234";

    makeNginxConfig = hostname: {
        enable = true;
        virtualHosts."${hostname}" = {
            root = "/etc";
            locations."/".index = "hostname";
            listen = [
                {
                    addr = hostname;
                    port = 80;
                }
                {
                    addr = hostname;
                    port = 8080;
                }
            ];
        };
    };

    makeCommonConfig = hostname: {
      services.nginx = makeNginxConfig hostname;
      services.vsftpd = {
        enable = true;
        anonymousUser = true;
        localRoot = "/etc/";
      };
      environment.systemPackages = [
        (pkgs.writeScriptBin "check-connection"
          ''
            #!/usr/bin/env bash

            set -e

            if [[ "$2" == "" || "$1" == "--help" || "$1" == "-h" ]];
            then
                echo "check-connection <target-hostname> <[expect-success|expect-failure]>"
                exit 1
            fi

            HOSTNAME="$1"

            function test_icmp() { timeout 3 ping -c 1 $HOSTNAME; }
            function test_http() { [[ `timeout 3 curl $HOSTNAME` == "$HOSTNAME" ]]; }
            function test_ftp() { timeout 3 curl ftp://$HOSTNAME; }

            if [[ "$2" == "expect-success" ]];
            then
                test_icmp; test_http; test_ftp
            else
                ! test_icmp; ! test_http; ! test_ftp
            fi
          ''
        )
        (pkgs.writeScriptBin "check-last-clients-ip"
          ''
            #!/usr/bin/env bash
            set -e

            [[ `cat /var/log/nginx/access.log | tail -n1 | awk '{print $1}'` == "$1" ]]
          ''
        )
      ];
    };

    # VLANS:
    # 1 -- simulates the internal network
    # 2 -- simulates the uninvolved network
    # 3 -- simulates the external network
    routerBase = nodes:
      lib.mkMerge [
        ( makeCommonConfig "router" )
        { virtualisation.vlans = [ 1 2 3 ];
          networking.firewall.enable = withFirewall;
          networking.firewall.filterForward = nftables;
          networking.nftables.enable = nftables;
          networking.nat =
            let
              clientIp = (pkgs.lib.head nodes.client.config.networking.interfaces.eth1.ipv4.addresses).address;
              serverIp = (pkgs.lib.head nodes.router.config.networking.interfaces.eth3.ipv4.addresses).address;
            in
            {
              internalIPs = [ "${clientIp}/24" ];
              externalInterface = "eth3";
              externalIP = serverIp;

              forwardPorts = [
                {
                  destination = "${clientIp}:8080";
                  proto = "tcp";
                  sourcePort = 8080;

                  loopbackIPs = [ serverIp ];
                }
              ];
            };

          networking.interfaces.eth3.ipv4.addresses =
              lib.mkOrder 10000 [ { address = routerAlternativeExternalIp; prefixLength = 24; } ];

          services.nginx.virtualHosts.router.listen = lib.mkOrder (-1) [ {
              addr = routerAlternativeExternalIp;
              port = 8080;
          } ];
        }

      ];
  in
  {
    name = "nat" + (lib.optionalString nftables "Nftables")
                 + (if withFirewall then "WithFirewall" else "Standalone");
    meta = with pkgs.lib.maintainers; {
      maintainers = [ gray-heron eelco rob ];
    };

    nodes =
      { client =
          { pkgs, nodes, ... }:
          lib.mkMerge [
            ( makeCommonConfig "client" )
            { virtualisation.vlans = [ 1 ];
              networking.defaultGateway =
                (pkgs.lib.head nodes.router.config.networking.interfaces.eth1.ipv4.addresses).address;
              networking.nftables.enable = nftables;
              networking.firewall.enable = false;
            }
          ];

        uninvolvedClient =
          { pkgs, nodes, ... }:
          lib.mkMerge [
            ( makeCommonConfig "uninvolvedClient" )
            { virtualisation.vlans = [ 2 ];
              networking.defaultGateway =
                (pkgs.lib.head nodes.router.config.networking.interfaces.eth2.ipv4.addresses).address;
              networking.nftables.enable = nftables;
              networking.firewall.enable = false;
            }
          ];

        router =
        { nodes, ... }: lib.mkMerge [
          (routerBase nodes)
          { networking.nat.enable = true;
          }
        ];

        routerDummyNoNat =
        { nodes, ... }: lib.mkMerge [
          (routerBase nodes)
          { networking.nat.enable = false; }
        ];

        server =
          { nodes, ... }: lib.mkMerge [
            ( makeCommonConfig "server" )
            { virtualisation.vlans = [ 3 ];
              networking.firewall.enable = false;

              # this is to simulate a potential attacker who tries to reach resources behind the NAT*
              networking.defaultGateway =
                (pkgs.lib.head nodes.router.config.networking.interfaces.eth3.ipv4.addresses).address;
            }
          ];
      };

    testScript =
      { nodes, ... }: let
        routerDummyNoNatClosure = nodes.routerDummyNoNat.config.system.build.toplevel;
        routerClosure = nodes.router.config.system.build.toplevel;
        clientIp = (pkgs.lib.head nodes.client.config.networking.interfaces.eth1.ipv4.addresses).address;
        serverIp = (pkgs.lib.head nodes.server.config.networking.interfaces.eth1.ipv4.addresses).address;
        routerIp = (pkgs.lib.head nodes.router.config.networking.interfaces.eth3.ipv4.addresses).address;
      in ''
        def wait_for_machine(m):
          m.wait_for_unit("network.target")
          m.wait_for_unit("nginx.service")

        client.start()
        uninvolvedClient.start()
        router.start()
        server.start()

        wait_for_machine(router)
        wait_for_machine(client)
        wait_for_machine(server)
        wait_for_machine(uninvolvedClient)

        # The router should have access to the server.
        router.succeed("check-connection server expect-success")

        # The client should be also able to connect via the NAT router...
        client.succeed("check-connection server expect-success")
        # ... but its IP should be rewritten.
        server.succeed("check-last-clients-ip ${routerIp}")

        # Active FTP should work directly...
        router.succeed("timeout 3 curl -P - ftp://server")
        # ... but not from behind NAT.
        client.fail("timeout 3 curl -P - ftp://server;")

        # The uninvolvedClient should not be able to connect via the NAT router.
        uninvolvedClient.succeed("check-connection server expect-failure")

        # The server should not be able to connect to anything via the NAT router...
        server.succeed("check-connection client expect-failure")
        server.succeed("check-connection uninvolvedClient expect-failure")

        # ... except for the port for which there is a forwarding configured!
        server.succeed('[[ `curl http://router:8080` == "client" ]]')
        client.succeed("check-last-clients-ip ${serverIp}")

        # But this forwarded port shouldn't intercept communication with
        # other IPs than externalIp.
        server.succeed('[[ `curl http://${routerAlternativeExternalIp}:8080` == "router" ]]')

        # The clients should not be able to reach each other.
        client.succeed("check-connection uninvolvedClient expect-failure")
        uninvolvedClient.succeed("check-connection client expect-failure")

        # The loopback should allow router to access the forwarded port.
        router.succeed('[[ `curl http://router:8080` == "client" ]]')

        # If we turn off NAT, nothing should work
        router.succeed(
            "systemctl stop nat.service"
        )

        client.succeed("check-connection server expect-failure")
        server.succeed("check-connection client expect-failure")
        server.succeed("check-connection uninvolvedClient expect-failure")
        server.fail("curl http://router:8080")
        router.fail("curl http://router:8080")

        # If we turn off NAT, nothing should work
        router.succeed(
            "systemctl start nat.service"
        )

        # If switch to a config without NAT at all, again nothing should work
        router.succeed(
            "${routerDummyNoNatClosure}/bin/switch-to-configuration test 2>&1"
        )

        client.succeed("check-connection server expect-failure")
        server.succeed("check-connection client expect-failure")
        server.succeed("check-connection uninvolvedClient expect-failure")
        server.fail("curl http://router:8080")
        router.fail("curl http://router:8080")
      '';
  })

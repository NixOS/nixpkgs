# This is a distributed test of the Network Address Translation involving a topology
# with a router inbetween three separate virtual networks:
# - "external" -- i.e. the internet,
# - "internal" -- i.e. an office LAN,
#
# This test puts one server on each of those networks and its primary goal is to ensure that:
# - server (named client in the code) in internal network can reach server (named server in the code) on the external network,
# - server in external network can not reach server in internal network (skipped in some cases),
# - when using externalIP, only the specified IP is used for NAT,
# - port forwarding functionality behaves correctly
#
# The client is behind the nat (read: protected by the nat) and the server is on the external network, attempting to access services behind the NAT.

import ./make-test-python.nix (
  {
    pkgs,
    lib,
    withFirewall ? false,
    nftables ? false,
    ...
  }:
  let
    unit = if nftables then "nftables" else (if withFirewall then "firewall" else "nat");

    routerAlternativeExternalIp = "192.168.2.234";

    makeNginxConfig = hostname: {
      enable = true;
      virtualHosts."${hostname}" = {
        root = "/etc";
        locations."/".index = "hostname";
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "0.0.0.0";
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
        extraConfig = ''
          pasv_min_port=51000
          pasv_max_port=51999
        '';
      };

      # Disable eth0 autoconfiguration
      networking.useDHCP = false;

      environment.systemPackages = [
        (pkgs.writeScriptBin "check-connection" ''
          #!/usr/bin/env bash

          set -e

          if [[ "$2" == "" || "$3" == "" || "$1" == "--help" || "$1" == "-h" ]];
          then
              echo "check-connection <target-address> <target-hostname> <[expect-success|expect-failure]>"
              exit 1
          fi

          ADDRESS="$1"
          HOSTNAME="$2"

          function test_icmp() { timeout 3 ping -c 1 $ADDRESS; }
          function test_http() { [[ `timeout 3 curl $ADDRESS` == "$HOSTNAME" ]]; }
          function test_ftp() { timeout 3 curl ftp://$ADDRESS; }

          if [[ "$3" == "expect-success" ]];
          then
              test_icmp; test_http; test_ftp
          else
              ! test_icmp; ! test_http; ! test_ftp
          fi
        '')
        (pkgs.writeScriptBin "check-last-clients-ip" ''
          #!/usr/bin/env bash
          set -e

          [[ `cat /var/log/nginx/access.log | tail -n1 | awk '{print $1}'` == "$1" ]]
        '')
      ];
    };

  in
  # VLANS:
  # 1 -- simulates the internal network
  # 2 -- simulates the external network
  {
    name =
      "nat"
      + (lib.optionalString nftables "Nftables")
      + (if withFirewall then "WithFirewall" else "Standalone");
    meta = with pkgs.lib.maintainers; {
      maintainers = [
        tne
        rob
      ];
    };

    nodes = {
      client =
        { pkgs, nodes, ... }:
        lib.mkMerge [
          (makeCommonConfig "client")
          {
            virtualisation.vlans = [ 1 ];
            networking.defaultGateway =
              (pkgs.lib.head nodes.router.networking.interfaces.eth1.ipv4.addresses).address;
            networking.nftables.enable = nftables;
            networking.firewall.enable = false;
          }
        ];

      router =
        { nodes, ... }:
        lib.mkMerge [
          (makeCommonConfig "router")
          {
            virtualisation.vlans = [
              1
              2
            ];
            networking.firewall = {
              enable = withFirewall;
              filterForward = nftables;
              allowedTCPPorts = [
                21
                80
                8080
              ];
              # For FTP passive mode
              allowedTCPPortRanges = [
                {
                  from = 51000;
                  to = 51999;
                }
              ];
            };
            networking.nftables.enable = nftables;
            networking.nat =
              let
                clientIp = (pkgs.lib.head nodes.client.networking.interfaces.eth1.ipv4.addresses).address;
                serverIp = (pkgs.lib.head nodes.router.networking.interfaces.eth2.ipv4.addresses).address;
              in
              {
                enable = true;
                internalIPs = [ "${clientIp}/24" ];
                # internalInterfaces = [ "eth1" ];
                externalInterface = "eth2";
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

            networking.interfaces.eth2.ipv4.addresses = lib.mkOrder 10000 [
              {
                address = routerAlternativeExternalIp;
                prefixLength = 24;
              }
            ];

            services.nginx.virtualHosts.router.listen = lib.mkOrder (-1) [
              {
                addr = routerAlternativeExternalIp;
                port = 8080;
              }
            ];

            specialisation.no-nat.configuration = {
              networking.nat.enable = lib.mkForce false;
            };
          }
        ];

      server =
        { nodes, ... }:
        lib.mkMerge [
          (makeCommonConfig "server")
          {
            virtualisation.vlans = [ 2 ];
            networking.firewall.enable = false;

            networking.defaultGateway =
              (pkgs.lib.head nodes.router.networking.interfaces.eth2.ipv4.addresses).address;
          }
        ];
    };

    testScript =
      { nodes, ... }:
      let
        clientIp = (pkgs.lib.head nodes.client.networking.interfaces.eth1.ipv4.addresses).address;
        serverIp = (pkgs.lib.head nodes.server.networking.interfaces.eth1.ipv4.addresses).address;
        routerIp = (pkgs.lib.head nodes.router.networking.interfaces.eth2.ipv4.addresses).address;
      in
      ''
        def wait_for_machine(m):
          m.wait_for_unit("network.target")
          m.wait_for_unit("nginx.service")

        client.start()
        router.start()
        server.start()

        wait_for_machine(router)
        wait_for_machine(client)
        wait_for_machine(server)

        # We assume we are isolated from layer 2 attacks or are securely configured (like disabling forwarding by default)
        # Relevant moby issue describing the problem allowing bypassing of NAT: https://github.com/moby/moby/issues/14041
        ${lib.optionalString (!nftables) ''
          router.succeed("iptables -P FORWARD DROP")
        ''}

        # Sanity checks.
        ## The router should have direct access to the server
        router.succeed("check-connection ${serverIp} server expect-success")
        ## The server should have direct access to the router
        server.succeed("check-connection ${routerIp} router expect-success")

        # The client should be also able to connect via the NAT router...
        client.succeed("check-connection ${serverIp} server expect-success")
        # ... but its IP should be rewritten to be that of the router.
        server.succeed("check-last-clients-ip ${routerIp}")

        # Active FTP (where the FTP server connects back to us via a random port) should work directly...
        router.succeed("timeout 3 curl -P eth2:51000-51999 ftp://${serverIp}")
        # ... but not from behind NAT.
        client.fail("timeout 3 curl -P eth1:51000-51999 ftp://${serverIp};")

        # If using nftables without firewall, filterForward can't be used and L2 security can't easily be simulated like with iptables, skipping.
        # See moby github issue mentioned above.
        ${lib.optionalString (nftables && withFirewall) ''
          # The server should not be able to reach the client directly...
          server.succeed("check-connection ${clientIp} client expect-failure")
        ''}
        # ... but the server should be able to reach a port forwarded address of the client
        server.succeed('[[ `timeout 3 curl http://${routerIp}:8080` == "client" ]]')
        # The IP address the client sees should not be rewritten to be that of the router (#277016)
        client.succeed("check-last-clients-ip ${serverIp}")

        # But this forwarded port shouldn't intercept communication with
        # other IPs than externalIp.
        server.succeed('[[ `timeout 3 curl http://${routerAlternativeExternalIp}:8080` == "router" ]]')

        # The loopback should allow the router itself to access the forwarded port
        # Note: The reason we use routerIp here is because only routerIp is listed for reflection in networking.nat.forwardPorts.loopbackIPs
        # The purpose of loopbackIPs is to allow things inside of the NAT to for example access their own public domain when a service has to make a request
        #   to itself/another service on the same NAT through a public address
        router.succeed('[[ `timeout 3 curl http://${routerIp}:8080` == "client" ]]')
        # The loopback should also allow the client to access its own forwarded port
        client.succeed('[[ `timeout 3 curl http://${routerIp}:8080` == "client" ]]')

        # If we turn off NAT, nothing should work
        router.succeed(
            "systemctl stop ${unit}.service"
        )

        # If using nftables and firewall, this makes no sense. We deactivated the firewall after all,
        # so we are once again affected by the same issue as the moby github issue mentioned above.
        # If using nftables without firewall, filterForward can't be used and L2 security can't easily be simulated like with iptables, skipping.
        # See moby github issue mentioned above.
        ${lib.optionalString (!nftables) ''
          client.succeed("check-connection ${serverIp} server expect-failure")
          server.succeed("check-connection ${clientIp} client expect-failure")
        ''}
        # These should revert to their pre-NATed versions
        server.succeed('[[ `timeout 3 curl http://${routerIp}:8080` == "router" ]]')
        router.succeed('[[ `timeout 3 curl http://${routerIp}:8080` == "router" ]]')

        # Reverse the effect of nat stop
        router.succeed(
            "systemctl start ${unit}.service"
          )

        # Switch to a config without NAT at all, again nothing should work
        router.succeed(
            "/run/booted-system/specialisation/no-nat/bin/switch-to-configuration test 2>&1"
        )

        # If using nftables without firewall, filterForward can't be used and L2 security can't easily be simulated like with iptables, skipping.
        # See moby github issue mentioned above.
        ${lib.optionalString (nftables && withFirewall) ''
          client.succeed("check-connection ${serverIp} server expect-failure")
          server.succeed("check-connection ${clientIp} client expect-failure")
        ''}

        # These should revert to their pre-NATed versions
        server.succeed('[[ `timeout 3 curl http://${routerIp}:8080` == "router" ]]')
        router.succeed('[[ `timeout 3 curl http://${routerIp}:8080` == "router" ]]')
      '';
  }
)

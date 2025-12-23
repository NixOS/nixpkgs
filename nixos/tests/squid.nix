# This is a distributed test of the Squid as a forward proxy
# - "external" -- i.e. the internet, where the proxy and server communicate
# - "internal" -- i.e. an office LAN, where the client and proxy communicat

{
  pkgs,
  lib,
  ...
}:
# VLANS:
# 1 -- simulates the internal network
# 2 -- simulates the external network
let
  commonConfig = {
    # Disable eth0 autoconfiguration
    networking.useDHCP = false;

    environment.systemPackages = [
      (pkgs.writeScriptBin "check-connection" ''
        #!/usr/bin/env bash

        set -e

        if [[ "$2" == "" || "$1" == "--help" || "$1" == "-h" ]];
        then
            echo "check-connection <target-address> <[expect-success|expect-failure]>"
            exit 1
        fi

        ADDRESS="$1"

        function test_icmp() { timeout 3 ping -c 1 "$ADDRESS"; }

        if [[ "$2" == "expect-success" ]];
        then
            test_icmp
        else
            ! test_icmp
        fi
      '')
    ];
  };
in
{
  name = "squid";
  meta.maintainers = with lib.maintainers; [ cobalt ];

  node.pkgsReadOnly = false;

  nodes = {
    client =
      { ... }:
      lib.mkMerge [
        commonConfig
        {
          virtualisation.vlans = [ 1 ];
          networking.firewall.enable = true;

          # NOTE: the client doesn't need a HTTP server, this is here to allow a validation of the proxy acl
          networking.firewall.allowedTCPPorts = [ 80 ];

          services.nginx = {
            enable = true;

            virtualHosts."server" = {
              root = "/etc";
              locations."/".index = "hostname";
              listen = [
                {
                  addr = "0.0.0.0";
                  port = 80;
                }
              ];
            };
          };
        }
      ];

    proxy =
      { config, nodes, ... }:
      let
        clientIp = (pkgs.lib.head nodes.client.networking.interfaces.eth1.ipv4.addresses).address;
        serverIp = (pkgs.lib.head nodes.server.networking.interfaces.eth1.ipv4.addresses).address;
      in
      lib.mkMerge [
        commonConfig
        {
          nixpkgs.config.permittedInsecurePackages = [ "squid-7.0.1" ];

          virtualisation.vlans = [
            1
            2
          ];
          networking.firewall.enable = true;
          networking.firewall.allowedTCPPorts = [ config.services.squid.proxyPort ];

          services.squid = {
            enable = true;

            extraConfig = ''
              acl client src ${clientIp}
              acl server dst ${serverIp}
              http_access allow client server
              http_access deny all
            '';
          };
        }
      ];

    server =
      { ... }:
      lib.mkMerge [
        commonConfig
        {
          virtualisation.vlans = [ 2 ];
          networking.firewall.enable = true;
          networking.firewall.allowedTCPPorts = [ 80 ];

          services.nginx = {
            enable = true;

            virtualHosts."server" = {
              root = "/etc";
              locations."/".index = "hostname";
              listen = [
                {
                  addr = "0.0.0.0";
                  port = 80;
                }
              ];
            };
          };
        }
      ];
  };

  testScript =
    { nodes, ... }:
    let
      clientIp = (pkgs.lib.head nodes.client.networking.interfaces.eth1.ipv4.addresses).address;
      serverIp = (pkgs.lib.head nodes.server.networking.interfaces.eth1.ipv4.addresses).address;
      proxyExternalIp = (pkgs.lib.head nodes.proxy.networking.interfaces.eth2.ipv4.addresses).address;
      proxyInternalIp = (pkgs.lib.head nodes.proxy.networking.interfaces.eth1.ipv4.addresses).address;
    in
    ''
      client.start()
      proxy.start()
      server.start()

      proxy.wait_for_unit("network.target")
      proxy.wait_for_unit("squid.service")
      client.wait_for_unit("network.target")
      server.wait_for_unit("network.target")
      server.wait_for_unit("nginx.service")

      # Topology checks.
      with subtest("proxy connectivity"):
          ## The proxy should have direct access to the server and client
          proxy.succeed("check-connection ${serverIp} expect-success")
          proxy.succeed("check-connection ${clientIp} expect-success")

      with subtest("server connectivity"):
          ## The server should have direct access to the proxy
          server.succeed("check-connection ${proxyExternalIp} expect-success")
          ## ... and not have access to the client
          server.succeed("check-connection ${clientIp} expect-failure")

      with subtest("client connectivity"):
          # The client should be also able to connect to the proxy
          client.succeed("check-connection ${proxyInternalIp} expect-success")
          # but not the client to the server
          client.succeed("check-connection ${serverIp} expect-failure")

      with subtest("HTTP"):
          # the client cannot reach the server directly over HTTP
          client.fail('[[ `timeout 3 curl --fail-with-body http://${serverIp}` ]]')
          # ... but can with the proxy
          client.succeed('[[ `timeout 3 curl --fail-with-body --proxy http://${proxyInternalIp}:3128 http://${serverIp}` == "server" ]]')
          # and cannot from the server (with a 4xx error code) and ...
          server.fail('[[ `timeout 3 curl --fail-with-body --proxy http://${proxyExternalIp}:3128 http://${clientIp}` == "client" ]]')
          # .. not the client hostname
          server.fail('[[ `timeout 3 curl --proxy http://${proxyExternalIp}:3128 http://${clientIp}` == "client" ]]')
          # with an explicit deny message (no --fail because we want to parse the returned message)
          server.succeed('[[ `timeout 3 curl --proxy http://${proxyExternalIp}:3128 http://${clientIp}` == *"ERR_ACCESS_DENIED"* ]]')
    '';
}

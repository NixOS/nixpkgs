{
  config,
  lib,
  pkgs,
  ...
}:
let
  domain = "example.test";

  dnsServerIP = nodes: nodes.dnsserver.networking.primaryIPAddress;

  dnsScript = pkgs.writeShellScript "dns-hook.sh" ''
    set -euo pipefail
    echo '[INFO]' "[$2]" 'dns-hook.sh' $*
    if [ "$1" = "present" ]; then
      ${pkgs.curl}/bin/curl --data @- http://dnsserver.test:8055/set-txt << EOF
      {"host": "$2", "value": "$3"}
    EOF
    else
      ${pkgs.curl}/bin/curl --data @- http://dnsserver.test:8055/clear-txt << EOF
      {"host": "$2"}
    EOF
    fi
  '';
in
{
  name = "dns01";
  meta = {
    maintainers = lib.teams.acme.members;
    # Hard timeout in seconds. Average run time is about 60 seconds.
    timeout = 180;
  };

  nodes = {
    # The fake ACME server which will respond to client requests
    acme =
      { nodes, ... }:
      {
        imports = [ ../common/acme/server ];
        networking.nameservers = lib.mkForce [ (dnsServerIP nodes) ];
      };

    # A fake DNS server which can be configured with records as desired
    # Used to test DNS-01 challenge
    dnsserver =
      { nodes, ... }:
      {
        networking = {
          firewall.allowedTCPPorts = [
            8055
            53
          ];
          firewall.allowedUDPPorts = [ 53 ];

          # nixos/lib/testing/network.nix will provide name resolution via /etc/hosts
          # for all nodes based on their host names and domain
          hostName = "dnsserver";
          domain = "test";
        };
        systemd.services.pebble-challtestsrv = {
          enable = true;
          description = "Pebble ACME challenge test server";
          wantedBy = [ "network.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.pebble}/bin/pebble-challtestsrv -dns01 ':53' -defaultIPv6 '' -defaultIPv4 '${nodes.client.networking.primaryIPAddress}'";
            # Required to bind on privileged ports.
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          };
        };
      };

    client =
      { nodes, ... }:
      {
        imports = [ ../common/acme/client ];
        networking.domain = domain;
        networking.nameservers = lib.mkForce [ (dnsServerIP nodes) ];

        # OpenSSL will be used for more thorough certificate validation
        environment.systemPackages = [ pkgs.openssl ];

        security.acme.certs."${domain}" = {
          domain = "*.${domain}";
          dnsProvider = "exec";
          dnsPropagationCheck = false;
          environmentFile = pkgs.writeText "wildcard.env" ''
            EXEC_PATH=${dnsScript}
            EXEC_POLLING_INTERVAL=1
            EXEC_PROPAGATION_TIMEOUT=1
            EXEC_SEQUENCE_INTERVAL=1
          '';
        };
      };
  };

  testScript = ''
    ${(import ./utils.nix).pythonUtils}

    cert = "${domain}"

    dnsserver.start()
    acme.start()

    wait_for_running(dnsserver)
    dnsserver.wait_for_open_port(53)
    wait_for_running(acme)
    acme.wait_for_open_port(443)

    with subtest("Boot and acquire a new cert"):
        client.start()
        wait_for_running(client)

        check_issuer(client, cert, "pebble")
        check_domain(client, cert, cert, fail=True)
        check_domain(client, cert, f"toodeep.nesting.{cert}", fail=True)
        check_domain(client, cert, f"whatever.{cert}")
  '';
}

{
  lib,
  pkgs,
  ...
}:
let
  # cant use .test, since that gets caught by traefik
  domain = "nixos.eu";
  subnet = "100.90.128.0/24";
  newtId = "this.is.the.newt.id";
  secret = "1234567890";
  orgId = "test_org_id";

  dbFilePath = "/var/lib/pangolin/config/db/db.sqlite";

  dnsServerIP = nodes: nodes.dnsserver.networking.primaryIPAddress;

  dnsScript = pkgs.writeShellScript "dns-hook.sh" ''
    set -euo pipefail
    echo '[INFO]' "[$2]" 'dns-hook.sh' $*
    if [ "$1" = "present" ]; then
      ${pkgs.curl}/bin/curl --data @- http://dnsserver.eu:8055/set-txt << EOF
      {"host": "$2", "value": "$3"}
    EOF
    else
      ${pkgs.curl}/bin/curl --data @- http://dnsserver.eu:8055/clear-txt << EOF
      {"host": "$2"}
    EOF
    fi
  '';

in
{
  name = "pangolin";
  meta.maintainers = [ lib.maintainers.jackr ];

  # stupid mulitline strings
  skipTypeCheck = true;
  skipLint = true;

  # a whole fleet of VM's TODO, explain how they work
  nodes = {
    # The fake ACME server which will respond to client requests
    acme =
      { nodes, ... }:
      {
        imports = [ ./common/acme/server ];
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
          domain = "eu";
        };
        systemd.services.pebble-challtestsrv = {
          enable = true;
          description = "Pebble ACME challenge test server";
          wantedBy = [ "network.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.pebble}/bin/pebble-challtestsrv -dns01 ':53' -defaultIPv6 '' -defaultIPv4 '${nodes.VPS.networking.primaryIPAddress}'";
            # Required to bind on privileged ports.
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          };
        };
      };

    VPS =
      { nodes, ...}:
      {
        imports = [ ./common/acme/client ];
        networking = {
          inherit domain;
          hosts.${nodes.VPS.networking.primaryIPAddress} = [ domain "pangolin.${domain}" ];
          nameservers = lib.mkForce [ (dnsServerIP nodes) ];
        };

        environment = {
          etc = {
            "nixos/secrets/pangolin.env".text = ''
              SERVER_SECRET=${secret}
            '';
          };
          systemPackages = with pkgs; [
            fosrl-pangolin
            sqlite
            unzip
            tree
            (writeScriptBin "create-org-db" ''
              ${lib.getExe sqlite} ${dbFilePath} <<'EOF'
              INSERT INTO orgs (orgId, name, subnet)
              VALUES ('${orgId}', 'org_test_name', '${subnet}');
              EOF
            '')
            (writeScriptBin "create-site-db" ''
              ${lib.getExe sqlite} ${dbFilePath} <<'EOF'
              INSERT INTO sites (siteId, orgId, niceId, exitNode, name, type, subnet, address)
              VALUES ('1', '${orgId}', '69_Id', '1','NixOS_test_site', 'newt', '100.89.128.4/30', '${subnet}')
              EOF
            '')
          ];
        };

        services = {
          pangolin = {
            enable = true;
            baseDomain = domain;
            letsEncryptEmail = "pangolin@${domain}";
            openFirewall = true;
            pangolinEnvironmentFile = "/etc/nixos/secrets/pangolin.env";
            settings = {
              flags.enable_integration_api = true;
            };
          };
          # set up local ca server, so we can get our certs signed without going on the internet
          traefik.staticConfigOptions.certificatesResolvers.letsencrypt.acme.caServer = lib.mkForce "https://${nodes.acme.test-support.acme.caDomain}/dir";
        };
      };

    privateHost =
      { nodes, ... }:
      {
        # TODO, check if this is correct.
        # API is unclear on what's what

        # make sure the certs are accepted as a valid authority
        imports = [ ./common/acme/client ];

        networking = {
          hosts.${nodes.VPS.networking.primaryIPAddress} = [ domain "pangolin.${domain}" ];
          nameservers = lib.mkForce [ (dnsServerIP nodes) ];
        };

        environment.systemPackages = [ pkgs.fosrl-newt pkgs.openssl ];
        environment.etc."nixos/secrets/newt.env".text = ''
          NEWT_ID=${newtId}
          NEWT_SECRET=${secret}
          DNS="${dnsServerIP nodes}"
          PANGOLIN_ENDPOINT=https://pangolin.${domain}
          LOG_LEVEL=DEBUG
        '';
        services.newt = {
          enable = true;
          environmentFile = "/etc/nixos/secrets/newt.env";
          # logLevel = "DEBUG";
        };
        systemd.services.newt.environment.SKIP_TLS_VERIFY = "true";
    };

    client =
      { nodes, ... }:
      {
        imports = [ ./common/acme/client ];
        networking = {
          domain = domain; # is this necesssary?
          nameservers = lib.mkForce [ (dnsServerIP nodes) ];
          hosts.${nodes.VPS.networking.primaryIPAddress} = [ domain ];
        };

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
  # general idea:
  # Panglin on the VPS, and Newt in the privateHost
  # setup ACME server to sign certificates and point
  # DNS to the correct machine
  /*
    Insert stuff into the db:
    1. org -> orgs
    2. site -> sites
  */
  testScript = ''
    # VPS.start()
    # privateHost.start()
    start_all()

    with subtest("start pangolin}"):
      VPS.wait_for_unit("pangolin.service")

    with subtest("start gerbil}"):
      VPS.wait_for_unit("gerbil.service")

    with subtest("start traefik}"):
      VPS.wait_for_unit("traefik.service")
      VPS.wait_for_open_port("7888")

    with subtest("create org and site"):
      VPS.wait_for_open_port("3004")
      VPS.succeed("create-org-db")
      VPS.succeed("create-site-db")

      VPS.succeed("sqlite3 ${dbFilePath} 'select * from orgs; select * from sites' >> /tmp/dbres")
      VPS.copy_from_vm("/tmp/dbres")
      VPS.copy_from_vm("/etc/badger")
  '';
}

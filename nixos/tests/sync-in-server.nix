{pkgs, ...}: let
  extraHosts = ''
    192.168.13.12 sync-in.example.com
  '';
in {
  name = "sync-in-server";
  meta.maintainers = with pkgs.lib.maintainers; [chris2fr];

  nodes = {
    server = {pkgs, ...}: {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            {
              address = "192.168.13.12";
              prefixLength = 24;
            }
          ];
        };
        inherit extraHosts;
        firewall.allowedTCPPorts = [8087];
      };
      environment.systemPackages = with pkgs; [
        sync-in-server
      ];
      services.sync-in-server = {
        enable = true;
        server = {
          port = 8087;
          publicUrl = "http://sync-in.example.com";
          host = "0.0.0.0";
        };
        logger.level = "info";
        admin = {
          passwordFile = "/etc/sync-in/admin.secret";
          login = "sync-in";
        };
        mysql = {
          passwordFile = "/etc/sync-in/mysql.password";
          user = "syncin";
          logQueries = false;
        };
        auth = {
          token = {
            access.secretFile = "/etc/sync-in/access.token";
            refresh.secretFile = "/etc/sync-in/refresh.token";
          };
        };
      };
    };

    client = {pkgs, ...}: {
      environment.systemPackages = [pkgs.jq];
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            {
              address = "192.168.13.1";
              prefixLength = 24;
            }
          ];
        };
        inherit extraHosts;
      };
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("postgresql.target")
    server.wait_for_unit("gancio")
    server.wait_for_unit("nginx")
    server.wait_for_file("/run/gancio/socket")
    server.wait_for_open_port(80)

    # Check can create user via cli
    server.succeed("cd /var/lib/gancio && sudo -u gancio gancio users create admin dummy admin")

    # Check event list is returned
    client.wait_until_succeeds("curl --verbose --fail-with-body http://agenda.example.com/api/events", timeout=30)

    server.shutdown()
    client.shutdown()
  '';
}

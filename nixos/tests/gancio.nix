{ pkgs, ... }:
let
  extraHosts = ''
    192.168.13.12 agenda.example.com
  '';
in
{
  name = "gancio";
  meta.maintainers = with pkgs.lib.maintainers; [ jbgi ];

  nodes = {
    server =
      { pkgs, ... }:
      {
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
          firewall.allowedTCPPorts = [ 80 ];
        };
        environment.systemPackages = [ pkgs.gancio ];
        services.gancio = {
          enable = true;
          settings = {
            hostname = "agenda.example.com";
            db.dialect = "postgres";
          };
          plugins = [ pkgs.gancioPlugins.telegram-bridge ];
          userLocale = {
            en = {
              register = {
                description = "My new registration page description";
              };
            };
          };
          nginx = {
            enableACME = false;
            forceSSL = false;
          };
        };
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jq ];
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

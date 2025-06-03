{ pkgs, ... }:
let
  key = pkgs.runCommand "key" { } "${pkgs.openssl}/bin/openssl rand 32 > $out";
in
{
  name = "spiped";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
  };

  nodes = {
    server =
      { pkgs, lib, ... }:
      {
        services.caddy = {
          enable = true;
          settings = {
            apps.http.servers.default = {
              listen = [ ":80" ];
              routes = [
                {
                  handle = [
                    {
                      body = "hello world";
                      handler = "static_response";
                      status_code = 200;
                    }
                  ];
                }
              ];
            };
          };
        };

        systemd.services."spiped@server" = {
          wantedBy = [ "multi-user.target" ];
          overrideStrategy = "asDropin";
        };
        systemd.services."spiped@client" = {
          wantedBy = [ "multi-user.target" ];
          overrideStrategy = "asDropin";
        };
        services.spiped = {
          enable = true;
          config = {
            server = {
              source = "localhost:8080";
              target = "localhost:80";
              keyfile = key;
              decrypt = true;
            };
            client = {
              source = "localhost:8081";
              target = "localhost:8080";
              keyfile = key;
              encrypt = true;
            };
          };
        };
      };
  };

  testScript =
    { nodes, ... }:
    ''
      server.wait_for_unit("caddy")
      server.wait_for_open_port(80)
      server.wait_for_open_port(8080)
      server.wait_for_open_port(8081)

      server.succeed("curl http://localhost:8081 | grep hello")
    '';
}

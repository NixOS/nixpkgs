{ lib, ... }:
{
  _class = "nixosTest";
  name = "autopush-rs";

  nodes = {
    machine =
      { pkgs, config, ... }:
      {
        environment.systemPackages = [
          pkgs.curl
        ];

        services.redis.servers.autopush-rs = {
          enable = true;
          port = 6000;
        };
        system.services.autopush-autoconnect = {
          imports = [
            pkgs.autopush-rs.services.autoconnect
          ];
          autoconnect.settings = {
            #do not use this key in production!!!
            crypto_key = "[fZQX8jgdESUYFTYfWw3Dv5RRMuwYJPPaaPcbUgHM69Q=]";
            db_dsn = "redis://localhost:${toString config.services.redis.servers.autopush-rs.port}";
            port = 8000;
          };
        };
        system.services.autopush-autoendpoint = {
          imports = [
            pkgs.autopush-rs.services.autoendpoint
          ];
          autoendpoint.settings = {
            #do not use this key in production!!!
            crypto_key = "[fZQX8jgdESUYFTYfWw3Dv5RRMuwYJPPaaPcbUgHM69Q=]";
            db_dsn = "redis://localhost:${toString config.services.redis.servers.autopush-rs.port}";
            port = 8080;
          };
        };

        networking.firewall.allowedTCPPorts = [
          8080
          8000
        ];
      };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("autopush-autoconnect.service")
    machine.wait_for_unit("autopush-autoendpoint.service")
    machine.wait_for_open_port(8080)
    machine.wait_for_open_port(8000)
    machine.succeed("curl -s -f http://localhost:8080/health")
    machine.succeed("curl -s -f http://localhost:8000/health")
  '';

  meta.maintainers = with lib.maintainers; [ zimward ];
}

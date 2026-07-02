{ pkgs, lib, ... }:

{
  name = "zenohd";
  meta.maintainers = [ lib.maintainers.markuskowa ];

  nodes = {
    router =
      {
        pkgs,
        config,
        ...
      }:
      {
        networking.firewall.allowedTCPPorts = [
          7447 # zenohd default port
          config.services.zenohd.settings.plugins.mqtt.port
          config.services.zenohd.settings.plugins.webserver.http_port
        ];

        services.zenohd = {
          enable = true;

          plugins = with pkgs; [
            zenoh-plugin-mqtt
            zenoh-plugin-webserver
          ];

          backends = with pkgs; [
            zenoh-backend-filesystem
            zenoh-backend-rocksdb
          ];

          settings = {
            plugins = {
              mqtt = {
                port = 1883;
                allow = ".*";
              };
              webserver.http_port = 8000;
              storage_manager = {
                volumes = {
                  fs = { };
                  rocksdb = { };
                };
                storages = {
                  mem = {
                    key_expr = "mem/**";
                    volume = "memory";
                  };
                  fs = {
                    key_expr = "fs/**";
                    volume = {
                      id = "fs";
                      dir = "zenoh-fs";
                      strip_prefix = "fs";
                    };
                  };
                  rocksdb = {
                    key_expr = "rocksdb/**";
                    volume = {
                      id = "rocksdb";
                      dir = "zenoh-rocksdb";
                      strip_prefix = "rocksdb";
                      create_db = true;
                    };
                  };
                };
              };
            };
          };
        };
      };

    client = {
      environment.systemPackages = [
        pkgs.mosquitto
      ];
    };
  };

  testScript = ''
    router.wait_for_unit("zenohd.service")
    client.wait_for_unit("multi-user.target")

    for be in ["fs", "rocksdb", "mem" ]:
      client.succeed(f"mosquitto_pub -h router -t {be}/test -m hello")
      client.succeed(f"curl router:8000/{be}/test | grep hello")
  '';
}

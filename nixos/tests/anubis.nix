{ lib, ... }:
{
  name = "anubis";
  meta.maintainers = with lib.maintainers; [
    soopyc
    nullcube
    ryand56
  ];

  nodes.machineLegacy =
    { config, pkgs, ... }:
    {
      services.anubis = {
        defaultOptions.settings = {
          DIFFICULTY = 3;
          USER_DEFINED_DEFAULT = true;
        };

        instances."".settings = {
          TARGET = "http://localhost:8080";
          DIFFICULTY = 5;
          USER_DEFINED_INSTANCE = true;
        };

        instances."tcp" = {
          user = "anubis-tcp";
          group = "anubis-tcp";
          settings = {
            TARGET = "http://localhost:8080";
            BIND = "127.0.0.1:9000";
            BIND_NETWORK = "tcp";
            METRICS_BIND = "127.0.0.1:9001";
            METRICS_BIND_NETWORK = "tcp";
          };
        };
      };

      # support
      users.users.nginx.extraGroups = [ config.users.groups.anubis.name ];
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts."basic.localhost".locations = {
          "/".proxyPass = "http://unix:/run/anubis/anubis.sock";
          "/metrics".proxyPass = "http://unix:/run/anubis/anubis-metrics.sock";
        };

        virtualHosts."tcp.localhost".locations = {
          "/".proxyPass = "http://${config.services.anubis.instances."tcp".settings.BIND}";
          "/metrics".proxyPass = "http://${config.services.anubis.instances."tcp".settings.METRICS_BIND}";
        };

        # emulate an upstream with nginx, listening on tcp and unix sockets.
        virtualHosts."upstream.localhost" = {
          default = true; # make nginx match this vhost for `localhost`
          listen = [
            { addr = "unix:/run/nginx/nginx.sock"; }
            {
              addr = "localhost";
              port = 8080;
            }
          ];
          locations."/" = {
            tryFiles = "$uri $uri/index.html =404";
            root = pkgs.runCommand "anubis-test-upstream" { } ''
              mkdir $out
              echo "it works" >> $out/index.html
            '';
          };
        };
      };

    };

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.anubis = {
        defaultOptions.settings = {
          DIFFICULTY = 3;
          USER_DEFINED_DEFAULT = true;
        };

        instances."".settings = {
          TARGET = "http://localhost:8080";
          DIFFICULTY = 5;
          USER_DEFINED_INSTANCE = true;
          BIND = "/run/anubis/anubis/anubis.sock";
          METRICS_BIND = "/run/anubis/anubis/anubis-metrics.sock";
        };

        instances."tcp" = {
          user = "anubis-tcp";
          group = "anubis-tcp";
          settings = {
            TARGET = "http://localhost:8080";
            BIND = "127.0.0.1:9000";
            BIND_NETWORK = "tcp";
            METRICS_BIND = "127.0.0.1:9001";
            METRICS_BIND_NETWORK = "tcp";
          };
        };
      };

      services.anubis.instances."another-unix-listen".settings = {
        TARGET = "http://localhost:8080";
        BIND = "/run/anubis/anubis-another-unix-listen/anubis.sock";
        METRICS_BIND = "/run/anubis/anubis-another-unix-listen/anubis-metrics.sock";
      };

      services.anubis.instances."unix-upstream" = {
        group = "nginx";
        settings = {
          BIND = "/run/anubis/anubis-unix-upstream/anubis.sock";
          METRICS_BIND = "/run/anubis/anubis-unix-upstream/anubis-metrics.sock";
          TARGET = "unix:///run/nginx/nginx.sock";
        };
      };

      # support
      users.users.nginx.extraGroups = [ config.users.groups.anubis.name ];
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts."basic.localhost".locations = {
          "/".proxyPass = lib.mkForce "http://unix:/run/anubis/anubis/anubis.sock";
          "/metrics".proxyPass = lib.mkForce "http://unix:/run/anubis/anubis/anubis-metrics.sock";
        };

        virtualHosts."tcp.localhost".locations = {
          "/".proxyPass = "http://${config.services.anubis.instances."tcp".settings.BIND}";
          "/metrics".proxyPass = "http://${config.services.anubis.instances."tcp".settings.METRICS_BIND}";
        };

        virtualHosts."another-unix-listen".locations = {
          "/".proxyPass = "http://unix:/run/anubis/anubis-another-unix-listen/anubis.sock";
          "/metrics".proxyPass = "http://unix:/run/anubis/anubis-another-unix-listen/anubis-metrics.sock";
        };

        virtualHosts."unix.localhost".locations = {
          "/".proxyPass = "http://unix:/run/anubis/anubis-unix-upstream/anubis.sock";
        };

        # emulate an upstream with nginx, listening on tcp and unix sockets.
        virtualHosts."upstream.localhost" = {
          default = true; # make nginx match this vhost for `localhost`
          listen = [
            { addr = "unix:/run/nginx/nginx.sock"; }
            {
              addr = "localhost";
              port = 8080;
            }
          ];
          locations."/" = {
            tryFiles = "$uri $uri/index.html =404";
            root = pkgs.runCommand "anubis-test-upstream" { } ''
              mkdir $out
              echo "it works" >> $out/index.html
            '';
          };
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      dedicatedRuntimeDirectory = "${nodes.machine.system.build.toplevel}/specialisation/dedicatedRuntimeDirectory";

    in
    ''
      with subtest("Legacy anubis service configuration: supports only a single RuntimeDirectory"):
        for unit in ["nginx", "anubis", "anubis-tcp"]:
          machineLegacy.wait_for_unit(unit + ".service")

        machineLegacy.wait_for_open_unix_socket("/run/anubis/anubis.sock")
        machineLegacy.wait_for_open_unix_socket("/run/anubis/anubis-metrics.sock")

        # Default unix socket mode with 1 instance listening on unix sockets.
        machineLegacy.succeed('curl -f http://basic.localhost | grep "it works"')
        machineLegacy.succeed('curl -f http://basic.localhost -H "User-Agent: Mozilla" | grep anubis')
        machineLegacy.succeed('curl -f http://basic.localhost/metrics | grep anubis_challenges_issued')

        # TCP mode.
        machineLegacy.succeed('curl -f http://tcp.localhost -H "User-Agent: Mozilla" | grep anubis')
        machineLegacy.succeed('curl -f http://tcp.localhost/metrics | grep anubis_challenges_issued')

      with subtest("Dedicated RuntimeDirectory"):
        for unit in ["nginx", "anubis", "anubis-another-unix-listen", "anubis-tcp", "anubis-unix-upstream"]:
          machine.wait_for_unit(unit + ".service")

        for port in [9000, 9001]:
          machine.wait_for_open_port(port)

        machine.wait_for_open_unix_socket("/run/anubis/anubis/anubis.sock")
        machine.wait_for_open_unix_socket("/run/anubis/anubis/anubis-metrics.sock")
        for instance in ["another-unix-listen", "unix-upstream"]:
          machine.wait_for_open_unix_socket(f"/run/anubis/anubis-{instance}/anubis.sock")
          machine.wait_for_open_unix_socket(f"/run/anubis/anubis-{instance}/anubis-metrics.sock")

        machine.succeed('curl -f http://basic.localhost | grep "it works"')
        machine.succeed('curl -f http://basic.localhost -H "User-Agent: Mozilla" | grep anubis')
        machine.succeed('curl -f http://basic.localhost/metrics | grep anubis_challenges_issued')

        machine.succeed('curl -f http://another-unix-listen.localhost -H "User-Agent: Mozilla" | grep anubis')
        machine.succeed('curl -f http://another-unix-listen.localhost/metrics | grep anubis_challenges_issued')

        # Upstream is a unix socket mode.
        machine.succeed('curl -f http://unix.localhost/index.html | grep "it works"')

        # Default user-defined environment variables.
        machine.succeed('cat /run/current-system/etc/systemd/system/anubis.service | grep "USER_DEFINED_DEFAULT"')
        machine.succeed('cat /run/current-system/etc/systemd/system/anubis-tcp.service | grep "USER_DEFINED_DEFAULT"')

        # Instance-specific user-specified environment variables.
        machine.succeed('cat /run/current-system/etc/systemd/system/anubis.service | grep "USER_DEFINED_INSTANCE"')
        machine.fail('cat /run/current-system/etc/systemd/system/anubis-tcp.service | grep "USER_DEFINED_INSTANCE"')

        # Make sure defaults don't overwrite themselves.
        machine.succeed('cat /run/current-system/etc/systemd/system/anubis.service | grep "DIFFICULTY=5"')
        machine.succeed('cat /run/current-system/etc/systemd/system/anubis-tcp.service | grep "DIFFICULTY=3"')
    '';
}

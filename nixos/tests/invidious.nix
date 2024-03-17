import ./make-test-python.nix ({ pkgs, ... }: {
  name = "invidious";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ sbruder ];
  };

  nodes = {
    postgres-tcp = { config, pkgs, ... }: {
      services.postgresql = {
        enable = true;
        initialScript = pkgs.writeText "init-postgres-with-password" ''
          CREATE USER invidious WITH PASSWORD 'correct horse battery staple';
          CREATE DATABASE invidious WITH OWNER invidious;
        '';
        enableTCPIP = true;
        authentication = ''
          host invidious invidious samenet scram-sha-256
        '';
      };
      networking.firewall.allowedTCPPorts = [ config.services.postgresql.settings.port ];
    };
    machine = { config, lib, pkgs, ... }: {
      services.invidious = {
        enable = true;
      };

      specialisation = {
        nginx.configuration = {
          services.invidious = {
            nginx.enable = true;
            domain = "invidious.example.com";
          };
          services.nginx.virtualHosts."invidious.example.com" = {
            forceSSL = false;
            enableACME = false;
          };
          networking.hosts."127.0.0.1" = [ "invidious.example.com" ];
        };
        nginx-scale.configuration = {
          services.invidious = {
            nginx.enable = true;
            domain = "invidious.example.com";
            serviceScale = 3;
          };
          services.nginx.virtualHosts."invidious.example.com" = {
            forceSSL = false;
            enableACME = false;
          };
          networking.hosts."127.0.0.1" = [ "invidious.example.com" ];
        };
        nginx-scale-ytproxy.configuration = {
          services.invidious = {
            nginx.enable = true;
            http3-ytproxy.enable = true;
            domain = "invidious.example.com";
            serviceScale = 3;
          };
          services.nginx.virtualHosts."invidious.example.com" = {
            forceSSL = false;
            enableACME = false;
          };
          networking.hosts."127.0.0.1" = [ "invidious.example.com" ];
        };
        postgres-tcp.configuration = {
          services.invidious = {
            database = {
              createLocally = false;
              host = "postgres-tcp";
              passwordFile = toString (pkgs.writeText "database-password" "correct horse battery staple");
            };
          };
        };
      };
    };
  };

  testScript = { nodes, ... }: ''
    def curl_assert_status_code(url, code, form=None):
        assert int(machine.succeed(f"curl -s -o /dev/null -w %{{http_code}} {'-F ' + form + ' ' if form else '''}{url}")) == code


    def activate_specialisation(name: str):
        machine.succeed(f"${nodes.machine.config.system.build.toplevel}/specialisation/{name}/bin/switch-to-configuration test >&2")


    url = "http://localhost:${toString nodes.machine.config.services.invidious.port}"
    port = ${toString nodes.machine.config.services.invidious.port}

    # start postgres vm now
    postgres_tcp.start()

    machine.wait_for_open_port(port)
    curl_assert_status_code(f"{url}/search", 200)

    activate_specialisation("nginx")
    machine.wait_for_open_port(80)
    curl_assert_status_code("http://invidious.example.com/search", 200)

    activate_specialisation("nginx-scale")
    machine.wait_for_open_port(80)
    # this depends on nginx round-robin behaviour for the upstream servers
    curl_assert_status_code("http://invidious.example.com/search", 200)
    curl_assert_status_code("http://invidious.example.com/search", 200)
    curl_assert_status_code("http://invidious.example.com/search", 200)
    machine.succeed("journalctl -eu invidious.service | grep -o '200 GET /search'")
    machine.succeed("journalctl -eu invidious-1.service | grep -o '200 GET /search'")
    machine.succeed("journalctl -eu invidious-2.service | grep -o '200 GET /search'")

    activate_specialisation("nginx-scale-ytproxy")
    machine.wait_for_unit("http3-ytproxy.service")
    machine.wait_for_open_port(80)
    machine.wait_until_succeeds("ls /run/http3-ytproxy/socket/http-proxy.sock")
    curl_assert_status_code("http://invidious.example.com/search", 200)
    # this should error out as no internet connectivity is available in the test
    curl_assert_status_code("http://invidious.example.com/vi/dQw4w9WgXcQ/mqdefault.jpg", 502)
    machine.succeed("journalctl -eu http3-ytproxy.service | grep -o 'dQw4w9WgXcQ'")

    postgres_tcp.wait_for_unit("postgresql.service")
    activate_specialisation("postgres-tcp")
    machine.wait_for_open_port(port)
    curl_assert_status_code(f"{url}/search", 200)
  '';
})

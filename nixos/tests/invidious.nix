import ./make-test-python.nix ({ pkgs, ... }: {
  name = "invidious";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ sbruder ];
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
      postgres-tcp.configuration = {
        services.invidious = {
          database = {
            createLocally = false;
            host = "127.0.0.1";
            passwordFile = toString (pkgs.writeText "database-password" "correct horse battery staple");
          };
        };
        # Normally not needed because when connecting to postgres over TCP/IP
        # the database is most likely on another host.
        systemd.services.invidious = {
          after = [ "postgresql.service" ];
          requires = [ "postgresql.service" ];
        };
        services.postgresql =
          let
            inherit (config.services.invidious.settings.db) dbname user;
          in
          {
            enable = true;
            initialScript = pkgs.writeText "init-postgres-with-password" ''
              CREATE USER kemal WITH PASSWORD 'correct horse battery staple';
              CREATE DATABASE invidious;
              GRANT ALL PRIVILEGES ON DATABASE invidious TO kemal;
            '';
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

    machine.wait_for_open_port(port)
    curl_assert_status_code(f"{url}/search", 200)

    activate_specialisation("nginx")
    machine.wait_for_open_port(80)
    curl_assert_status_code("http://invidious.example.com/search", 200)

    # Remove the state so the `initialScript` gets run
    machine.succeed("systemctl stop postgresql")
    machine.succeed("rm -r /var/lib/postgresql")
    activate_specialisation("postgres-tcp")
    machine.wait_for_open_port(port)
    curl_assert_status_code(f"{url}/search", 200)
  '';
})

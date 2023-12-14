import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "freshrss";
  meta.maintainers = with lib.maintainers; [ etu stunkymonkey ];

  nodes.machine = { pkgs, ... }: {
    services.freshrss = {
      enable = true;
      baseUrl = "http://localhost";
      passwordFile = pkgs.writeText "password" "secret";
      dataDir = "/srv/freshrss";
      database = {
        type = "pgsql";
        port = 5432;
        user = "freshrss";
        passFile = pkgs.writeText "db-password" "db-secret";
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "freshrss" ];
      ensureUsers = [
        {
          name = "freshrss";
          ensureDBOwnership = true;
        }
      ];
      initialScript = pkgs.writeText "postgresql-password" ''
        CREATE ROLE freshrss WITH LOGIN PASSWORD 'db-secret' CREATEDB;
      '';
    };

    systemd.services."freshrss-config" = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_open_port(5432)
    machine.wait_for_open_port(80)
    response = machine.succeed("curl -vvv -s -H 'Host: freshrss' http://127.0.0.1:80/i/")
    assert '<title>Login · FreshRSS</title>' in response, "Login page didn't load successfully"
  '';
})

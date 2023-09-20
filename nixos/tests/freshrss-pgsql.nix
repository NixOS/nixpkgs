import ./make-test-python.nix ({ lib, pkgs, ... }: let
  dbPasswordFile = pkgs.writeText "db-password" "db-secret";
in {
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
        passFile = dbPasswordFile;
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [
        {
          name = "freshrss";
          owner = "freshrss";
        }
      ];
      ensureUsers = [
        {
          name = "freshrss";
          passwordFile = dbPasswordFile;
        }
      ];
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

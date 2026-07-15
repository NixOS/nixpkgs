{ lib, ... }:
{
  name = "postgres-websockets";

  meta = {
    maintainers = with lib.maintainers; [ wolfgangwalther ];
  };

  nodes.machine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [ pkgs.websocat ];

      services.postgresql = {
        enable = true;
        initialScript = pkgs.writeText "init.sql" ''
          CREATE ROLE "postgres-websockets" LOGIN NOINHERIT;
          CREATE ROLE "postgres-websockets_with_password" LOGIN NOINHERIT PASSWORD 'password';
        '';
      };

      services.postgres-websockets = {
        enable = true;
        jwtSecretFile = "/run/secrets/jwt.secret";
        environment.PGWS_DB_URI.dbname = "postgres";
        environment.PGWS_LISTEN_CHANNEL = "websockets-listener";
      };

      specialisation.withPassword.configuration = {
        services.postgresql.enableTCPIP = true;
        services.postgres-websockets = {
          pgpassFile = "/run/secrets/.pgpass";
          environment.PGWS_DB_URI.host = "localhost";
          environment.PGWS_DB_URI.user = "postgres-websockets_with_password";
        };
      };
    };

  extraPythonPackages = p: [ p.pyjwt ];

  testScript =
    { nodes, ... }:
    let
      withPassword = "${nodes.machine.system.build.toplevel}/specialisation/withPassword";
    in
    ''
      machine.execute("""
        mkdir -p /run/secrets
        echo reallyreallyreallyreallyverysafe > /run/secrets/jwt.secret
      """)

      import jwt
      token = jwt.encode({ "mode": "rw" }, "reallyreallyreallyreallyverysafe")

      def test():
          machine.wait_for_unit("postgresql.target")
          machine.wait_for_unit("postgres-websockets.service")

          machine.succeed(f"echo 'hi there' | websocat --no-close 'ws://localhost:3000/test/{token}' > output &")
          machine.sleep(1)
          machine.succeed("grep 'hi there' output")

          machine.succeed("""
            sudo -u postgres psql -c "SELECT pg_notify('websockets-listener', json_build_object('channel', 'test', 'event', 'message', 'payload', 'Hello World')::text);" >/dev/null
          """)
          machine.sleep(1)
          machine.succeed("grep 'Hello World' output")

      with subtest("without password"):
          test()

      with subtest("with password"):
          machine.execute("""
            echo "*:*:*:*:password" > /run/secrets/.pgpass
          """)
          machine.succeed("${withPassword}/bin/switch-to-configuration test >&2")
          test()
    '';
}

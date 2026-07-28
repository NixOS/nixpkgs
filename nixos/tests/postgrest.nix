{ lib, ... }:
{
  name = "postgrest";

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
      services.postgresql = {
        enable = true;
        initialScript = pkgs.writeText "init.sql" ''
          CREATE ROLE postgrest LOGIN NOINHERIT;
          CREATE ROLE anon ROLE postgrest;

          CREATE ROLE postgrest_with_password LOGIN NOINHERIT PASSWORD 'password';
          CREATE ROLE authenticated ROLE postgrest_with_password;
        '';
      };

      services.postgrest = {
        enable = true;
        settings = {
          admin-server-port = 3001;
          db-anon-role = "anon";
          db-uri.dbname = "postgres";
        };
      };

      specialisation.withSecrets.configuration = {
        services.postgresql.enableTCPIP = true;
        services.postgrest = {
          pgpassFile = "/run/secrets/.pgpass";
          jwtSecretFile = "/run/secrets/jwt.secret";
          settings.db-uri.host = "localhost";
          settings.db-uri.user = "postgrest_with_password";
          settings.server-port = 3000;
          settings.server-unix-socket = null;
        };
      };
    };

  extraPythonPackages = p: [ p.pyjwt ];

  testScript =
    { nodes, ... }:
    let
      withSecrets = "${nodes.machine.system.build.toplevel}/specialisation/withSecrets";
    in
    ''
      import jwt

      machine.wait_for_unit("postgresql.target")

      def wait_for_postgrest():
          machine.wait_for_unit("postgrest.service")
          machine.wait_until_succeeds("curl --fail -s http://localhost:3001/ready", timeout=30)

      with subtest("anonymous access"):
          wait_for_postgrest()
          machine.succeed(
            "curl --fail-with-body --no-progress-meter --unix-socket /run/postgrest/postgrest.sock http://localhost",
            timeout=2
          )

      machine.execute("""
        mkdir -p /run/secrets
        echo "*:*:*:*:password" > /run/secrets/.pgpass
        echo reallyreallyreallyreallyverysafe > /run/secrets/jwt.secret
      """)

      with subtest("authenticated access"):
          machine.succeed("${withSecrets}/bin/switch-to-configuration test >&2")
          wait_for_postgrest()
          token = jwt.encode({ "role": "authenticated" }, "reallyreallyreallyreallyverysafe")
          machine.succeed(
            f"curl --fail-with-body --no-progress-meter -H 'Authorization: Bearer {token}' http://localhost:3000",
            timeout=2
          )
    '';
}

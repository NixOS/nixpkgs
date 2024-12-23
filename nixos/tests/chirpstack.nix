{
  system ? builtins.currentSystem,
  pkgs ? import ../.. {
    inherit system;
    config = { };
  },
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  inherit (pkgs.lib) optionalString;
in
makeTest {
  name = "chirpstack";
  nodes = {
    server =
      { config, ... }:
      {
        services = {
          postgresql.enable = true;
          redis.servers."".enable = true;
          mosquitto.enable = true;
          chirpstack = {
            enable = true;
            settings = {
              monitoring = {
                bind = "[::]:8081";
              };
            };
          };
        };

        systemd.services.chirpstack-postgresql =
          let
            pgsql = config.services.postgresql;
          in
          {
            after = [ "postgresql.service" ];
            bindsTo = [ "postgresql.service" ];
            wantedBy = [ "chirpstack.service" ];
            partOf = [ "chirpstack.service" ];
            path = [
              pgsql.package
            ];
            script = ''
              set -o errexit -o pipefail -o nounset -o errtrace
              shopt -s inherit_errexit

              psql << EOF
              CREATE USER chirpstack WITH ENCRYPTED PASSWORD 'chirpstack';
              CREATE DATABASE chirpstack OWNER chirpstack;
              EOF

              psql chirpstack << EOF
              CREATE EXTENSION IF NOT EXISTS pg_trgm;
              EOF
            '';

            serviceConfig = {
              User = pgsql.superUser;
              Type = "oneshot";
              RemainAfterExit = true;
            };
          };
      };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("chirpstack.service")

    server.wait_for_open_port(8080)

    with subtest("Check health endpoint"):
      server.succeed("curl --silent --fail http://localhost:8081/health")

    with subtest("Check Web interface"):
      out = server.succeed("curl --silent http://localhost:8080")
      assert "ChirpStack LoRaWAN&reg; Network-Server" in out
  '';
}

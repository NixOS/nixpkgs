import ./make-test-python.nix (
  { lib, ... }:
  let
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spacetimedb" ];
    port1 = 3000;
    port2 = 3005;
  in
  {
    name = "spacetimedb";
    meta.maintainers = [ lib.maintainers.akotro ];

    nodes = {
      machine1 =
        { ... }:
        {
          nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate;

          services.spacetimedb = {
            enable = true;
            nginx = {
              enable = true;
              domain = "localhost";
            };
          };
        };

      machine2 =
        { ... }:
        {
          nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate;

          services.spacetimedb = {
            enable = true;
            server.port = port2;
            nginx = {
              enable = true;
              domain = "localhost";
            };
          };
        };
    };

    testScript = ''
      start_all()

      machine1.wait_for_unit("spacetimedb.service")
      machine1.wait_for_unit("nginx.service")
      machine1.wait_for_open_port(${toString port1})

      machine2.wait_for_unit("spacetimedb.service")
      machine2.wait_for_unit("nginx.service")
      machine2.wait_for_open_port(${toString port2})

      with subtest("Ping spacetimedb on machine1 (default port: ${toString port1})"):
        machine1.succeed("curl --fail --show-error --silent http://localhost:${toString port1}/v1/ping")
        machine1.succeed("spacetime server ping local | grep 'Server is online'")

      with subtest("Ping spacetimedb on machine2 (non-default port: ${toString port2})"):
        machine2.succeed("spacetime server edit local --url http://localhost:${toString port2} --yes")
        machine2.succeed("curl --fail --show-error --silent http://localhost:${toString port2}/v1/ping")
        machine2.succeed("spacetime server ping local | grep 'Server is online'")
    '';
  }
)

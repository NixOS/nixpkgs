import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "spacetimedb";
    meta.maintainers = [ lib.maintainers.akotro ];

    nodes.machine =
      { ... }:
      {
        nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spacetimedb" ];

        services.spacetimedb = {
          enable = true;
          nginx = {
            enable = true;
            domain = "localhost";
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("spacetimedb.service")
      machine.wait_for_unit("nginx.service")
      machine.wait_for_open_port(3000)

      machine.succeed("curl --fail --show-error --silent http://localhost:3000/v1/ping")
      machine.succeed("spacetime server ping local | grep 'Server is online'")
    '';
  }
)

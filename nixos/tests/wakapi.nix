import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "Wakapi";

    nodes.machine = {
      services.wakapi = {
        enable = true;
        settings = {
          server.port = 3000; # upstream default, set explicitly in case upstream changes it

          db = {
            dialect = "postgres"; # `createLocally` only supports postgres
            host = "/run/postgresql";
            port = 5432; # service will fail if port is not set
            name = "wakapi";
            user = "wakapi";
          };
        };

        database.createLocally = true;

        # Created with `cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1`
        # Prefer passwordSaltFile in production.
        passwordSalt = "NpqCY7eY7fMoIWYmPx5mAgr6YoSlXSuI";
      };
    };

    # Test that the service is running and that it is reachable.
    # This is not very comprehensive for a test, but it should
    # catch very basic mistakes in the module.
    testScript = ''
      machine.wait_for_unit("wakapi.service")
      machine.wait_for_open_port(3000)
      machine.succeed("curl --fail http://localhost:3000")
    '';

    meta.maintainers = [ lib.maintainers.NotAShelf ];
  }
)

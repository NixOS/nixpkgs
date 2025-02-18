import ./make-test-python.nix (
  { lib, pkgs, ... }:

  {
    name = "crabfit";

    meta.maintainers = [ ];

    nodes = {
      machine =
        { pkgs, ... }:
        {
          services.crabfit = {
            enable = true;

            frontend.host = "http://127.0.0.1:3001";
            api.host = "127.0.0.1:3000";
          };
        };
    };

    # TODO: Add a reverse proxy and a dns entry for testing
    testScript = ''
      machine.wait_for_unit("crabfit-api")
      machine.wait_for_unit("crabfit-frontend")

      machine.wait_for_open_port(3000)
      machine.wait_for_open_port(3001)

      machine.succeed("curl -f http://localhost:3001/")
    '';
  }
)

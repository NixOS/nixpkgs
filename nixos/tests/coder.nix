import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "coder";
    meta.maintainers = pkgs.coder.meta.maintainers;

    nodes.machine =
      { pkgs, ... }:
      {
        services.coder = {
          enable = true;
          accessUrl = "http://localhost:3000";
        };
      };

    testScript = ''
      machine.start()
      machine.wait_for_unit("postgresql.service")
      machine.wait_for_unit("coder.service")
      machine.wait_for_open_port(3000)

      machine.succeed("curl --fail http://localhost:3000")
    '';
  }
)

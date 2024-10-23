import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "ShokoServer";

    nodes.machine = {
      services.shokoserver.enable = true;
    };
    testScript = ''
      machine.wait_for_unit("shokoserver.service")
      machine.wait_for_open_port(8111)
      machine.succeed("curl --fail http://localhost:8111")
    '';

    meta.maintainers = [ lib.maintainers.diniamo ];
  }
)

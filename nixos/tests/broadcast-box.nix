import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "broadcast-box";
    meta.maintainers = with lib.maintainers; [ JManch ];

    nodes.machine =
      { ... }:
      {
        services.broadcast-box.enable = true;
      };

    testScript = ''
      machine.wait_for_unit("broadcast-box.service")
      machine.wait_for_open_port(8080)
      machine.succeed("curl --fail http://localhost:8080/")
    '';
  }
)

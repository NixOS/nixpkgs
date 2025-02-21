import ./make-test-python.nix (
  { lib, ... }:

  {
    name = "pocket-id";
    meta.maintainers = with lib.maintainers; [
      gepbird
      ymstnt
    ];

    nodes = {
      machine =
        { ... }:
        {
          services.pocket-id = {
            enable = true;
          };
        };
    };

    testScript = ''
      machine.wait_for_unit("pocket-id-backend.service")
      machine.wait_for_unit("pocket-id-frontend.service")
      machine.wait_for_open_port(3000)
      machine.succeed("curl http://localhost:3000")
    '';
  }
)

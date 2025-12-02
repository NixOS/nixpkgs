import ./make-test-python.nix (
  { lib, ... }:

  {
    name = "ersatztv";
    meta.maintainers = with lib.maintainers; [ allout58 ];

    nodes.machine =
      { ... }:
      {
        services.ersatztv.enable = true;
      };

    # ErsatzTV doesn't really have an API to speak of currently, so just check if it responds at all
    testScript = ''
      machine.wait_for_unit("ersatztv.service")
      machine.wait_for_open_port(8409)
      machine.succeed("curl --fail http://localhost:8409/")
    '';
  }
)

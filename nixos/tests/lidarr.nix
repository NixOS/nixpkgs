import ./make-test-python.nix (
  { lib, ... }:

  {
    name = "lidarr";
    meta.maintainers = with lib.maintainers; [ etu ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.lidarr.enable = true;
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("lidarr.service")
      machine.wait_for_open_port(8686)
      machine.succeed("curl --fail http://localhost:8686/")
    '';
  }
)

import ./make-test-python.nix (
  { lib, ... }:

  with lib;

  {
    name = "audiobookshelf";
    meta.maintainers = with maintainers; [ wietsedv ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.audiobookshelf = {
          enable = true;
          port = 1234;
        };
      };

    testScript = ''
      machine.wait_for_unit("audiobookshelf.service")
      machine.wait_for_open_port(1234)
      machine.succeed("curl --fail http://localhost:1234/")
    '';
  }
)

import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "readarr";
    meta.maintainers = with lib.maintainers; [ jocelynthode ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.readarr.enable = true;
      };

    testScript = ''
      machine.wait_for_unit("readarr.service")
      machine.wait_for_open_port(8787)
      machine.succeed("curl --fail http://localhost:8787/")
    '';
  }
)

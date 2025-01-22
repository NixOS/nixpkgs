import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "pykms-test";
    meta.maintainers = with pkgs.lib.maintainers; [ zopieux ];

    nodes.machine =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        services.pykms.enable = true;
      };

    testScript = ''
      machine.wait_for_unit("pykms.service")
      machine.succeed("${pkgs.pykms}/bin/client")
    '';
  }
)

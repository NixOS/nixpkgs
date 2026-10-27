{ lib, ... }:
{
  name = "zerobyte";
  meta.maintainers = with lib.maintainers; [ pbek ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.zerobyte = {
        enable = true;
        settings.BASE_URL = "http://localhost:4096";
        # Test-only secret; a real deployment would use sops/agenix instead of
        # a file in the Nix store.
        environmentFile = pkgs.writeText "zerobyte.env" ''
          APP_SECRET=94bad469e4b4e7c7f5a2b6a8c0d2e4f6a8b0c2d4e6f8a0b2c4d6e8f0a2b4c66e25
        '';
      };
    };

  testScript = ''
    machine.wait_for_unit("zerobyte.service")
    machine.wait_for_open_port(4096)
    machine.succeed("curl --fail -o /dev/null http://localhost:4096/")
  '';
}

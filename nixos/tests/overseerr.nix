{ lib, pkgs, ... }:
{
  name = "overseerr";
  meta.maintainers = with lib.maintainers; [ jf-uu ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.jq ];
      services.overseerr.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("overseerr.service")
    machine.wait_for_open_port(5055)

    version = machine.succeed("curl --fail http://localhost:5055/api/v1/status | jq --raw-output .version").rstrip("\n")
    assert version == "${pkgs.overseerr.version}", f"expected version to be ${pkgs.overseerr.version}, got {version}"
  '';
}

{ pkgs, lib, ... }:
{
  name = "photonvision";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.photonvision = {
          enable = true;
        };
      };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("photonvision.service")
    machine.wait_for_open_port(5800)
  '';

  meta.maintainers = with lib.maintainers; [ max-niederman ];
}

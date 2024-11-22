{ lib, ... }:

{
  name = "glances";

  nodes = {
    machine_default =
      { pkgs, ... }:
      {
        services.glances = {
          enable = true;
        };
      };

    machine_custom_port =
      { pkgs, ... }:
      {
        services.glances = {
          enable = true;
          port = 5678;
        };
      };
  };

  testScript = ''
    machine_default.start()
    machine_default.wait_for_unit("glances.service")
    machine_default.wait_for_open_port(61208)

    machine_custom_port.start()
    machine_custom_port.wait_for_unit("glances.service")
    machine_custom_port.wait_for_open_port(5678)
  '';

  meta.maintainers = [ lib.maintainers.claha ];
}

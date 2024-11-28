{ lib, ... }:

{
  name = "glance";

  nodes = {
    machine_default =
      { pkgs, ... }:
      {
        services.glance = {
          enable = true;
        };
      };

    machine_custom_port =
      { pkgs, ... }:
      {
        services.glance = {
          enable = true;
          settings.server.port = 5678;
        };
      };
  };

  testScript = ''
    machine_default.start()
    machine_default.wait_for_unit("glance.service")
    machine_default.wait_for_open_port(8080)

    machine_custom_port.start()
    machine_custom_port.wait_for_unit("glance.service")
    machine_custom_port.wait_for_open_port(5678)
  '';

  meta.maintainers = [ lib.maintainers.drupol ];
}

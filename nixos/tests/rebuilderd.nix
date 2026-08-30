{ lib, ... }:

{
  name = "rebuilderd";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.rebuilderd = {
          enable = true;
        };
      };

    machine_custom_config =
      { pkgs, ... }:
      {
        services.rebuilderd = {
          enable = true;
          settings = {
            http.bind_addr = "0.0.0.0:1234";
          };
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("rebuilderd.service")
    machine.wait_for_open_port(8484)

    machine_custom_config.start()
    machine_custom_config.wait_for_unit("rebuilderd.service")
    machine_custom_config.wait_for_open_port(1234)
  '';

  meta.maintainers = [ ];
}

{ lib, ... }:

{
  name = "drupal";

  nodes = {
    machine_default =
      { pkgs, ... }:
      {
        services.drupal = {
          enable = true;
        };
      };
  };

  testScript = ''
    machine_default.start()
    machine_default.wait_for_unit("drupal.service")
    machine_default.wait_for_open_port(8080)
  '';

  meta.maintainers = [ lib.maintainers.drupol ];
}

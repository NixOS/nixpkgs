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
    machine_default.wait_for_unit("phpfpm-drupal-localhost.service")
    machine_default.wait_for_unit("nginx.service")
    machine_default.wait_for_unit("mysql.service")
  '';

  meta.maintainers = [
    lib.maintainers.drupol
    lib.maintainers.OulipianSummer
  ];
}

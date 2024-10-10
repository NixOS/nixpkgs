{ lib, ... }:

{
  name = "reposilite";

  nodes = {
    machine_default =
      { pkgs, ... }:
      {
        services.reposilite = {
          enable = true;
        };
      };
  };

  testScript = ''
    machine_default.start()
    machine_default.wait_for_unit("reposilite.service")
    machine_default.wait_for_open_port(8080)
  '';

  meta.maintainers = [ lib.maintainers.jamalam ];
}

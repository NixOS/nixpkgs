import ./make-test-python.nix ({pkgs, lib, ...}:
{
  name = "guacamole-server";

  nodes = {
    machine = {pkgs, ...}: {
      services.guacamole-server = {
        enable = true;
        host = "0.0.0.0";
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("guacamole-server.service")
    machine.wait_for_open_port(4822)
  '';

  meta.maintainers = [ lib.maintainers.drupol ];
})

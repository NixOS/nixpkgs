{ lib, ... }:

{
  name = "kanboard";
  meta.maintainers = with lib.maintainers; [ yzx9 ];

  nodes = {
    machine = {
      services.kanboard = {
        enable = true;
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("phpfpm-kanboard.service")
    machine.wait_for_open_port(80)

    machine.succeed("curl -k --fail http://localhost", timeout=10)
  '';
}

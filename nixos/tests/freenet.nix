{ lib, ... }:

{
  name = "freenet";
  meta = {
    maintainers = with lib.maintainers; [ nagy ];
  };

  nodes = {
    machine = {
      services.freenet.enable = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("freenet.service")
    machine.wait_for_open_port(8888)
    machine.wait_until_succeeds("curl -sfL http://localhost:8888/ | grep Freenet")
    machine.succeed("systemctl stop freenet")
  '';
}

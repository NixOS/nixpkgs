{ lib, ... }:

{
  name = "yamtrack";

  nodes.machine = {
    services.yamtrack = {
      enable = true;
      port = 8002;
    };
    networking.firewall.allowedTCPPorts = [ 80 ];
  };

  testScript = ''
    machine.wait_for_unit('yamtrack.target')

    @polling_condition
    def yamtrack_running():
      machine.fail("systemctl is-failed yamtrack-migrate")
      machine.fail("systemctl is-failed yamtrack-main")

    with yamtrack_running: # type: ignore[union-attr]
      machine.wait_for_open_port(8002) # yamtrack
      machine.wait_for_open_port(80) # nginx

      res = machine.succeed("curl http://yamtrack.localhost -L")
      assert "Yamtrack" in res

      res = machine.succeed("curl http://yamtrack.localhost/static/css/main.css")
      assert "font-family" in res
  '';

  meta.maintainers = with lib.maintainers; [ dav-wolff ];
}

{ lib, ... }:
{
  name = "hister";

  meta = {
    maintainers = with lib.maintainers; [ FlameFlag ];
  };

  nodes.machine = {
    services.hister = {
      enable = true;
      port = 4433;
      settings.app.log_level = "debug";
    };
  };

  testScript = ''
    machine.wait_for_unit("hister.service")
    machine.wait_for_open_port(4433)
    machine.succeed("curl -fsS http://localhost:4433/ >/dev/null")
  '';
}

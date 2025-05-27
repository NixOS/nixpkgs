{ lib, ... }:
{
  name = "grist";
  meta.maintainers = with lib.maintainers; [ scandiravian ];

  nodes.machine = {
    services.grist-core = {
      enable = true;

      settings = {
        DEBUG = "1";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("grist-core.service")
    machine.wait_until_succeeds("curl --fail http://[::1]:8484", 15)
  '';
}

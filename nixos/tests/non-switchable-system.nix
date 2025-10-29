{ lib, ... }:

{
  name = "non-switchable-system";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = {
    system.switch.enable = false;
  };

  testScript = ''
    machine.succeed("test ! -e /run/current-system/bin/switch-to-configuration")
  '';
}

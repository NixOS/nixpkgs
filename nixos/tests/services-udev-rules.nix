{ lib, ... }:
{
  name = "services-udev-rules";

  meta = {
    maintainers = with lib.maintainers; [
      l0b0
    ];
  };

  nodes.machine = {
    config.services.udev.rules = {
      "00-high-prio" = ''
        # high prio content
      '';
      "99-custom" = ''
        # low prio content
      '';
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    high_prio_contents = machine.succeed("cat /etc/udev/rules.d/00-high-prio.rules")
    assert '# high prio content\n' == high_prio_contents

    low_prio_contents = machine.succeed("cat /etc/udev/rules.d/99-custom.rules")
    assert '# low prio content\n' == low_prio_contents
  '';
}

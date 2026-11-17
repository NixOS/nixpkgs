{ lib, ... }:
{
  name = "services-udev-rules";

  meta = {
    maintainers = with lib.maintainers; [
      l0b0
    ];
  };

  nodes.machine = {
    config.services.udev = {
      rules = {
        "00-high-prio" = ''
          # high prio content
        '';
        "99-custom" = ''
          # low prio content
        '';
        "99-local" = ''
          # rules attrset content
        '';
      };
      extraRules = ''
        # extraRules string content
      '';
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("Puts services.udev.rules exact content in named files"):
      high_prio_contents = machine.succeed("cat /etc/udev/rules.d/00-high-prio.rules")
      assert '# high prio content\n' == high_prio_contents

      low_prio_contents = machine.succeed("cat /etc/udev/rules.d/99-custom.rules")
      assert '# low prio content\n' == low_prio_contents

    with subtest("Merges services.udev.rules and extraRules"):
      local_content = machine.succeed("cat /etc/udev/rules.d/99-local.rules")
      assert '# rules attrset content\n' in local_content
      assert '# extraRules string content\n' in local_content
  '';
}

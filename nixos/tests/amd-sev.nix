{ lib, ... }: {
  name = "amd-sev";
  meta = {
    maintainers = with lib.maintainers; [ trundle veehaitch ];
  };

  nodes.machine = { lib, ... }: {
    hardware.cpu.amd.sev.enable = true;
    hardware.cpu.amd.sevGuest.enable = true;

    specialisation.sevCustomUserGroup.configuration = {
      users.groups.sevtest = { };

      hardware.cpu.amd.sev = {
        enable = true;
        group = "root";
        mode = "0600";
      };
      hardware.cpu.amd.sevGuest = {
        enable = true;
        group = "sevtest";
      };
    };
  };

  testScript = { nodes, ... }:
    let
      specialisations = "${nodes.machine.system.build.toplevel}/specialisation";
    in
    ''
      machine.wait_for_unit("multi-user.target")

      with subtest("Check default settings"):
        out = machine.succeed("cat /etc/udev/rules.d/99-local.rules")
        assert 'KERNEL=="sev", OWNER="root", GROUP="sev", MODE="0660"' in out
        assert 'KERNEL=="sev-guest", OWNER="root", GROUP="sev-guest", MODE="0660"' in out

        out = machine.succeed("cat /etc/group")
        assert "sev:" in out
        assert "sev-guest:" in out
        assert "sevtest:" not in out

      with subtest("Activate configuration with custom user/group"):
        machine.succeed('${specialisations}/sevCustomUserGroup/bin/switch-to-configuration test')

      with subtest("Check custom user and group"):
        out = machine.succeed("cat /etc/udev/rules.d/99-local.rules")
        assert 'KERNEL=="sev", OWNER="root", GROUP="root", MODE="0600"' in out
        assert 'KERNEL=="sev-guest", OWNER="root", GROUP="sevtest", MODE="0660"' in out

        out = machine.succeed("cat /etc/group")
        assert "sev:" not in out
        assert "sev-guest:" not in out
        assert "sevtest:" in out
    '';
}

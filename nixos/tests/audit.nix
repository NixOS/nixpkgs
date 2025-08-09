{

  name = "audit";

  nodes = {
    machine =
      { lib, pkgs, ... }:
      {
        security.audit = {
          enable = true;
          rules = [
            "-a always,exit -F exe=${lib.getExe pkgs.hello} -k nixos-test"
          ];
        };
        security.auditd.enable = true;

        environment.systemPackages = [ pkgs.hello ];
      };
  };

  testScript = ''
    machine.wait_for_unit("audit-rules.service")
    machine.wait_for_unit("auditd.service")

    with subtest("Audit subsystem gets enabled"):
      assert "enabled 1" in machine.succeed("auditctl -s")

    with subtest("Custom rule produces audit traces"):
      machine.succeed("hello")
      print(machine.succeed("ausearch -k nixos-test -sc exit_group"))

    with subtest("Stopping audit-rules.service disables the audit subsystem"):
      machine.succeed("systemctl stop audit-rules.service")
      assert "enabled 0" in machine.succeed("auditctl -s")
  '';

}

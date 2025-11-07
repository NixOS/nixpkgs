{ pkgs, ... }:

{
  name = "systemd-journal";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ lewo ];
  };

  nodes.machine = {
    environment.systemPackages = [ pkgs.audit ];
  };
  nodes.auditd = {
    security.auditd.enable = true;
    security.audit.enable = true;
  };
  nodes.journaldAudit = {
    services.journald.audit = true;
    security.audit.enable = true;
  };
  nodes.containerCheck = {
    containers.c1 = {
      autoStart = true;
      config = { };
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("journalctl --grep=systemd")

    with subtest("no audit messages"):
      machine.fail("journalctl _TRANSPORT=audit --grep 'unit=systemd-journald'")
      machine.fail("journalctl _TRANSPORT=kernel --grep 'unit=systemd-journald'")

    with subtest("auditd enabled"):
      auditd.wait_for_unit("multi-user.target")

      # logs should end up in the journald
      auditd.succeed("journalctl _TRANSPORT=audit --grep 'unit=systemd-journald'")
      # logs should end up in the auditd audit log
      auditd.succeed("grep 'unit=systemd-journald' /var/log/audit/audit.log")
      # logs should not end up in kmesg
      auditd.fail("journalctl _TRANSPORT=kernel --grep 'unit=systemd-journald'")


    with subtest("journald audit"):
      journaldAudit.wait_for_unit("multi-user.target")

      # logs should end up in the journald
      journaldAudit.succeed("journalctl _TRANSPORT=audit --grep 'unit=systemd-journald'")
      # logs should NOT end up in audit log
      journaldAudit.fail("grep 'unit=systemd-journald' /var/log/audit/audit.log")


    with subtest("container systemd-journald-audit not running"):
      containerCheck.wait_for_unit("multi-user.target");
      containerCheck.wait_until_succeeds("systemctl -M c1 is-active default.target");

      # systemd-journald-audit.socket should exist but not run due to the upstream unit's `Condition*` settings
      (status, output) = containerCheck.execute("systemctl -M c1 is-active systemd-journald-audit.socket")
      containerCheck.log(output)
      assert status == 3 and output == "inactive\n", f"systemd-journald-audit.socket should exist in a container but remain inactive, was {output}"
  '';
}

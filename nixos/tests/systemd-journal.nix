import ./make-test-python.nix (
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
      environment.systemPackages = [ pkgs.audit ];
    };
    nodes.journaldAudit = {
      services.journald.audit = true;
      environment.systemPackages = [ pkgs.audit ];
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
        machine.fail("journalctl _TRANSPORT=kernel --grep 'unit=systemd-journald'")


      with subtest("journald audit"):
        journaldAudit.wait_for_unit("multi-user.target")

        # logs should end up in the journald
        journaldAudit.succeed("journalctl _TRANSPORT=audit --grep 'unit=systemd-journald'")
        # logs should NOT end up in audit log
        journaldAudit.fail("grep 'unit=systemd-journald' /var/log/audit/audit.log")
        # FIXME: If systemd fixes #15324 this test will start failing.
        # You can fix this text by removing the below line.
        # logs ideally should NOT end up in kmesg, but they do due to
        # https://github.com/systemd/systemd/issues/15324
        journaldAudit.succeed("journalctl _TRANSPORT=kernel --grep 'unit=systemd-journald'")
    '';
  }
)

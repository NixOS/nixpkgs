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
      security.audit.enable = true;
      environment.systemPackages = [ pkgs.audit ];
      boot.kernel.sysctl."kernel.printk_ratelimit" = 0;
      boot.kernelParams = [ "audit_backlog_limit=8192" ];
    };
    nodes.journaldAudit = {
      services.journald.audit = true;
      security.audit.enable = true;
      environment.systemPackages = [ pkgs.audit ];
      boot.kernel.sysctl."kernel.printk_ratelimit" = 0;
      boot.kernelParams = [ "audit_backlog_limit=8192" ];
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

      with subtest("container systemd-journald-audit disabled"):
        containerCheck.wait_for_unit("multi-user.target");
        containerCheck.wait_until_succeeds("systemctl -M c1 is-active default.target");

        # systemd-journald-audit.socket should not exist, so we expect exit status 4: "no such unit"
        (status, output) = containerCheck.execute("systemctl -M c1 status systemd-journald-audit.socket")
        containerCheck.log(output)
        assert status == 4, f"systemd-journald-audit.socket should not exist in a container so we expect an exit status of 4, but status was: {status}"

    '';
  }
)

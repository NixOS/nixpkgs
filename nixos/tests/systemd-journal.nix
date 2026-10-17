{ lib, pkgs, ... }:

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
    # Verify that the module's option default remains overridable by downstream defaults.
    services.journald.settings.Journal.Audit = lib.mkDefault true;
    security.audit.enable = true;
  };
  nodes.namespaced = {
    services.journald.namespaces.namespace-test.settings.Journal.Storage = "volatile";
    systemd.services.log-for-namespace-test = {
      serviceConfig = {
        Type = "oneshot";
        LogNamespace = "namespace-test";
        ExecStart = "${pkgs.coreutils}/bin/echo hello-from-namespace-test";
      };
    };
  };
  nodes.containerCheck = {
    containers.c1 = {
      autoStart = true;
      config = {
        nix.enable = false; # disabled by default on the test's host. See all-tests.nix / tag(no-nix-by-default)
      };
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
      journaldAudit.succeed("grep -Fx 'Audit=true' /etc/systemd/journald.conf")

      # logs should end up in the journald
      journaldAudit.succeed("journalctl _TRANSPORT=audit --grep 'unit=systemd-journald'")
      # logs should NOT end up in audit log
      journaldAudit.fail("grep 'unit=systemd-journald' /var/log/audit/audit.log")


    with subtest("journal namespaces"):
      namespaced.wait_for_unit("multi-user.target")
      namespaced.succeed("grep -Fx 'Storage=volatile' /etc/systemd/journald@namespace-test.conf")
      namespaced.systemctl("start log-for-namespace-test.service")
      namespaced.wait_until_succeeds("journalctl --namespace=namespace-test --grep=hello-from-namespace-test")
      namespaced.succeed("systemctl is-active systemd-journald@namespace-test.service")
      # volatile storage lands under /run, not /var
      namespaced.succeed("find /run/log/journal/$(cat /etc/machine-id).namespace-test -name '*.journal' | grep -q .")
      namespaced.fail("find /var/log/journal/$(cat /etc/machine-id).namespace-test -name '*.journal' | grep -q .")
      # the default namespace must not see it
      namespaced.fail("journalctl --grep=hello-from-namespace-test")


    with subtest("container systemd-journald-audit not running"):
      containerCheck.wait_for_unit("multi-user.target");
      containerCheck.wait_until_succeeds("systemctl -M c1 is-active default.target");

      # systemd-journald-audit.socket should exist but not run due to the upstream unit's `Condition*` settings
      (status, output) = containerCheck.execute("systemctl -M c1 is-active systemd-journald-audit.socket")
      containerCheck.log(output)
      assert status == 3 and output == "inactive\n", f"systemd-journald-audit.socket should exist in a container but remain inactive, was {output}"
  '';
}

{ lib, ... }:
{
  # https://github.com/linux-audit/audit-testsuite
  # This test is meant to *only* run the audit regression testsuite.
  # The test mutates the audit rules on the system it runs on, and can not run in the nix build sandbox.
  # Thus a dedicated VM test makes sense.

  name = "audit-testsuite";

  meta = {
    maintainers = with lib.maintainers; [ grimmauld ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      # https://github.com/linux-audit/audit-testsuite/blob/5a10451642ac1ba2fa4b31c06a21cf9aa2d38b66/tests/amcast_joinpart/test#L86
      # tests use LC_TIME=en_DK.utf8 to force ISO 8601 date format
      i18n.extraLocales = [ "en_DK.UTF-8/UTF-8" ];

      security.polkit.enable = true; # needed for run0

      security.audit.backlogLimit = 8192;

      security.auditd = {
        enable = true;
        plugins.af_unix.active = true;
        settings = {
          num_logs = 4;
          disk_full_action = "rotate";
        };
      };

      environment.systemPackages = [ pkgs.audit.testsuite.runner ];
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("auditd.service")
    machine.wait_for_unit("network.target") # netfilter test requires network to be up

    # we need a valid session to which we can send commands, so we use run0
    machine.succeed("run0 --pty audit-testsuite-runner")
  '';
}

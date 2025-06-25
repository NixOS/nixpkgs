{ lib, ... }:
{
  name = "auditd";

  meta = {
    maintainers = with lib.maintainers; [ grimmauld ];
  };

  nodes.machine = {
    security.audit.enable = true;
    security.auditd = {
      enable = true;
      plugins.af_unix.active = true;
      plugins.syslog.active = true;
      # plugins.remote.active = true; # needs configuring a remote server for logging
      # plugins.filter.active = true; # needs configuring allowlist/denylist
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("auditd.service")
    machine.succeed("stat /var/run/audispd_events")
  '';
}

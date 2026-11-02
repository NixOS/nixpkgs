{ lib, ... }:
{

  name = "utmp";

  meta = {
    maintainers = with lib.maintainers; [ grimmauld ];
  };

  nodes = {
    machine = {
      imports = [ ./common/user-account.nix ];
      security.audit.enable = true;
      security.auditd.enable = true;
    };
  };

  testScript = ''
    import re

    def extract_utmp_fields(line: str) -> tuple[str, str] | None:
      m = re.match(r"^\[\d*\]\s*\[\d*\]\s*\[([^\]\s]*)\s*]\s*\[([^\]\s]*)\s*]", line)
      if not m:
          return None
      return m.group(1), m.group(2)

    machine.wait_for_unit("auditd.service")
    machine.wait_for_unit("systemd-update-utmp.service")
    machine.wait_for_file("/run/utmp")

    with subtest("systemd updated utmp"):
      utmp = machine.succeed("utmpdump /run/utmp").strip().split("\n")
      print(utmp)
      assert extract_utmp_fields(utmp[0]) == ("~~", "reboot") # first entry is the reboot

    with subtest("Test utmp entries are created by logins"):
      machine.wait_for_unit("multi-user.target")
      machine.wait_until_tty_matches("1", "login: ")
      machine.send_chars("alice\n")
      machine.wait_until_tty_matches("1", "Password: ")
      machine.send_chars("foobar\n")
      machine.wait_until_succeeds("pgrep -u alice bash")
      utmp = machine.succeed("utmpdump /run/utmp").strip().split("\n")
      print(utmp)
      assert extract_utmp_fields(utmp[1]) == ("tty1", "alice") # second entry is alice login
      machine.send_chars("exit\n")
      machine.wait_until_fails("pgrep -u alice bash")

    with subtest("Test utmp entries are cleaned after logout"):
      utmp = machine.succeed("utmpdump /run/utmp").strip().split("\n")
      print(utmp)
      assert extract_utmp_fields(utmp[1]) in [("tty1", ""), ("tty1", "LOGIN")] # tty1 previously in use by alice is now clear

    with subtest("audit logs utmp system boot"):
      audit_log = machine.succeed("ausearch -m SYSTEM_BOOT")
      print(audit_log)
      # audit 4.2.1 truncates too long comm entries, while systemd shortened the entry from `systemd-update-utmp` (truncated) to `update-utmp`
      # see also:
      # - systemd: https://github.com/systemd/systemd/pull/43144
      # - audit: https://github.com/linux-audit/audit-userspace/commit/d7ea98263ebdb974b383a4057856a5ec339776fc
      # accept either fix in this test
      assert 'comm="update-utmp"' in audit_log or f'comm="{"systemd-update-utmp"[:15]}"' in audit_log
  '';

}

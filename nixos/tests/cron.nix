{ lib, ... }:
{
  name = "cron";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  nodes.machine = {
    imports = [ ./common/user-account.nix ];

    services.postfix.enable = true;

    services.cron = {
      enable = true;
      mailto = "alice";
      systemCronJobs = [
        "* * * * * root touch /tmp/cron-executed; echo cron-mail-marker"
      ];
    };
  };

  testScript = ''
    machine.wait_for_unit("cron.service")
    machine.wait_for_unit("postfix.service")

    machine.wait_until_succeeds("test -e /tmp/cron-executed")
    machine.wait_until_succeeds("grep -qr cron-mail-marker /var/spool/mail/alice/new")
  '';
}

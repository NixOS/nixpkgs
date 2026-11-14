{ lib, ... }:
{
  name = "fcron";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  nodes.machine = {
    imports = [ ./common/user-account.nix ];

    services.postfix.enable = true;

    services.fcron = {
      enable = true;
      systab = ''
        MAILTO=alice
        @ 5s touch /tmp/fcron-executed; echo fcron-mail-marker
      '';
    };
  };

  testScript = ''
    machine.wait_for_unit("fcron.service")
    machine.wait_for_unit("postfix.service")

    machine.wait_until_succeeds("test -e /tmp/fcron-executed")
    machine.wait_until_succeeds("grep -qr fcron-mail-marker /var/spool/mail/alice/new")
  '';
}

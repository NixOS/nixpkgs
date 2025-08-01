{ lib, ... }:
{
  name = "systemd-user-linger";

  nodes.machine =
    { ... }:
    {
      users.users = {
        alice = {
          isNormalUser = true;
          linger = true;
          uid = 1000;
        };

        bob = {
          isNormalUser = true;
          linger = false;
          uid = 10001;
        };
      };
    };

  testScript =
    { ... }:
    ''
      machine.wait_for_file("/var/lib/systemd/linger/alice")
      machine.succeed("systemctl status user-1000.slice")

      machine.fail("test -e /var/lib/systemd/linger/bob")
      machine.fail("systemctl status user-1001.slice")

      with subtest("missing users have linger purged"):
          machine.succeed("touch /var/lib/systemd/linger/missing")
          machine.systemctl("restart linger-users")
          machine.succeed("test ! -e /var/lib/systemd/linger/missing")
    '';
}

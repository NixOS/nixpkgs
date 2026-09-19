{ ... }:

{
  name = "pam-lastlog";

  nodes = {
    machine1 =
      { ... }:
      {
        imports = [ ../common/user-account.nix ];
      };

    machine2 =
      { ... }:
      {
        imports = [ ../common/user-account.nix ];
        security.pam.services.login.lastlog.require = true;
      };
  };

  testScript = ''
    start_all()

    def login(machine, succeed=True):
      machine.wait_for_unit("multi-user.target")
      machine.wait_until_tty_matches("1", "login: ")
      machine.send_chars("alice\n")
      machine.wait_until_tty_matches("1", "Password: ")
      machine.send_chars("foobar\n")
      if succeed:
        machine.wait_until_succeeds("pgrep -u alice bash")
        print(machine.succeed("lastlog2 --active --user alice"))
        machine.succeed("stat /var/lib/lastlog/lastlog2.db")
        machine.send_chars("exit\n")
      else:
        machine.wait_until_tty_matches("1", "login: ")

    with subtest("Test legacy lastlog import"):
      # create old lastlog file to test import
      # empty = nothing will actually be imported, but the service will run
      machine1.succeed("touch /var/log/lastlog")
      machine1.wait_for_unit("lastlog2-import.service")
      machine1.succeed("journalctl -b --grep 'Starting Import lastlog data into lastlog2 database'")
      machine1.succeed("stat /var/log/lastlog.migrated")

    with subtest("Test lastlog entries are created by logins"):
      login(machine1)

    with subtest("Test login succeeds with read-only disk by default"):
      machine1.succeed("mount -o bind,ro /var /var")
      login(machine1)
      machine1.succeed("umount /var")

    with subtest("Test login fails with read-only disk when disallowed"):
      machine2.succeed("mount -o bind,ro /var /var")
      login(machine2, succeed=False)
      machine2.wait_until_succeeds("journalctl --grep='SQL error: attempt to write a readonly database'")
      machine2.fail("pgrep -u alice bash")
      machine2.succeed("umount /var")
  '';
}

{ ... }:

{
  name = "pam-lastlog";

  nodes.machine =
    { ... }:
    {
      imports = [ ../common/user-account.nix ];
    };

  testScript = ''
    with subtest("Test legacy lastlog import"):
      # create old lastlog file to test import
      # empty = nothing will actually be imported, but the service will run
      machine.succeed("touch /var/log/lastlog")
      machine.wait_for_unit("lastlog2-import.service")
      machine.succeed("journalctl -b --grep 'Starting Import lastlog data into lastlog2 database'")
      machine.succeed("stat /var/log/lastlog.migrated")

    with subtest("Test lastlog entries are created by logins"):
      machine.wait_for_unit("multi-user.target")
      machine.wait_until_tty_matches("1", "login: ")
      machine.send_chars("alice\n")
      machine.wait_until_tty_matches("1", "Password: ")
      machine.send_chars("foobar\n")
      machine.wait_until_succeeds("pgrep -u alice bash")
      print(machine.succeed("lastlog2 --active --user alice"))
      machine.succeed("stat /var/lib/lastlog/lastlog2.db")
      machine.send_chars("exit\n")
  '';
}

{ ... }:

{
  name = "pam-lastlog";

  nodes.machine =
    { ... }:
    {
      # we abuse run0 for a quick login as root as to not require setting up accounts and passwords
      security.pam.services.systemd-run0 = {
        updateWtmp = true; # enable lastlog
      };
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
      machine.succeed("run0 --pty true") # perform full login
      print(machine.succeed("lastlog2 --active --user root"))
      machine.succeed("stat /var/lib/lastlog/lastlog2.db")
  '';
}

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
    machine.wait_for_unit("multi-user.target")
    machine.succeed("run0 --pty true") # perform full login
    print(machine.succeed("lastlog2 --active --user root"))
    machine.succeed("stat /var/lib/lastlog/lastlog2.db")
  '';
}

import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "atd";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ bjornfor ];
    };

    nodes.machine =
      { ... }:
      {
        services.atd.enable = true;
        users.users.alice = {
          isNormalUser = true;
        };
      };

    # "at" has a resolution of 1 minute
    testScript = ''
      start_all()

      machine.wait_for_unit("atd.service")  # wait for atd to start
      machine.fail("test -f ~root/at-1")
      machine.fail("test -f ~alice/at-1")

      machine.succeed("echo 'touch ~root/at-1' | at now+1min")
      machine.succeed("su - alice -c \"echo 'touch at-1' | at now+1min\"")

      machine.succeed("sleep 1.5m")

      machine.succeed("test -f ~root/at-1")
      machine.succeed("test -f ~alice/at-1")
    '';
  }
)

import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "novacomd";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ dtzWill ];
    };

    nodes.machine =
      { ... }:
      {
        services.novacomd.enable = true;
      };

    testScript = ''
      machine.wait_for_unit("novacomd.service")

      with subtest("Make sure the daemon is really listening"):
          machine.wait_for_open_port(6968)
          machine.succeed("novacom -l")

      with subtest("Stop the daemon, double-check novacom fails if daemon isn't working"):
          machine.stop_job("novacomd")
          machine.fail("novacom -l")

      with subtest("Make sure the daemon starts back up again"):
          machine.start_job("novacomd")
          # make sure the daemon is really listening
          machine.wait_for_open_port(6968)
          machine.succeed("novacom -l")
    '';
  }
)

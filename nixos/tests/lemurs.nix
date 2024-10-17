import ./make-test-python.nix (
  {
    pkgs,
    latestKernel ? false,
    ...
  }:
  {
    name = "lemurs";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ stunkymonkey ];
    };

    nodes.machine =
      { pkgs, lib, ... }:
      {

        users.users.alice = {
          isNormalUser = true;
          group = "alice";
          password = "foobar";
        };
        users.groups.alice = { };

        services.lemurs = {
          enable = true;
        };
      };

    testScript = ''
      machine.start()

      machine.wait_for_unit("multi-user.target")
      machine.wait_until_succeeds("pgrep -f 'lemurs.*tty1'")
      machine.screenshot("postboot")
      with subtest("Log in as alice on a virtual console"):

        machine.send_chars("\n")
        machine.send_chars("alice\n")
        machine.sleep(1)
        machine.send_chars("foobar\n")
        machine.sleep(1)

        machine.screenshot("postlogin")
        machine.wait_until_tty_matches("1", "alice@machine:")

        machine.wait_until_succeeds("pgrep -u alice bash")
        machine.send_chars("touch done\n")
        machine.wait_for_file("/home/alice/done")
    '';
  }
)

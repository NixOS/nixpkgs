import ./make-test-python.nix (
  {
    pkgs,
    latestKernel ? false,
    ...
  }:
  {
    name = "greetd-no-shadow";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ ];
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

        # This means login(1) breaks, so we must use greetd/agreety instead.
        security.shadow.enable = false;

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${pkgs.greetd.greetd}/bin/agreety --cmd bash";
            };
          };
        };
      };

    testScript = ''
      machine.start()

      machine.wait_for_unit("multi-user.target")
      machine.wait_until_succeeds("pgrep -f 'agretty.*tty1'")
      machine.screenshot("postboot")

      with subtest("Log in as alice on a virtual console"):
          machine.wait_until_tty_matches("1", "login: ")
          machine.send_chars("alice\n")
          machine.wait_until_tty_matches("1", "login: alice")
          machine.wait_until_succeeds("pgrep login")
          machine.wait_until_tty_matches("1", "Password: ")
          machine.send_chars("foobar\n")
          machine.wait_until_succeeds("pgrep -u alice bash")
          machine.send_chars("touch done\n")
          machine.wait_for_file("/home/alice/done")
    '';
  }
)

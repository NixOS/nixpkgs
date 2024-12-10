import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "user-home-mode";
    meta = with lib.maintainers; {
      maintainers = [ fbeffa ];
    };

    nodes.machine = {
      users.users.alice = {
        initialPassword = "pass1";
        isNormalUser = true;
      };
      users.users.bob = {
        initialPassword = "pass2";
        isNormalUser = true;
        homeMode = "750";
      };
    };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("getty@tty1.service")
      machine.wait_until_tty_matches("1", "login: ")
      machine.send_chars("alice\n")
      machine.wait_until_tty_matches("1", "Password: ")
      machine.send_chars("pass1\n")
      machine.succeed('[ "$(stat -c %a /home/alice)" == "700" ]')
      machine.succeed('[ "$(stat -c %a /home/bob)" == "750" ]')
    '';
  }
)

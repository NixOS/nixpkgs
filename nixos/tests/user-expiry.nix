let
  alice = "alice";
  bob = "bob";
  eve = "eve";
  passwd = "pass1";
in
{
  name = "user-expiry";

  nodes = {
    machine = {
      users.users = {
        ${alice} = {
          initialPassword = passwd;
          isNormalUser = true;
          expires = "1990-01-01";
        };
        ${bob} = {
          initialPassword = passwd;
          isNormalUser = true;
          expires = "2990-01-01";
        };
        ${eve} = {
          initialPassword = passwd;
          isNormalUser = true;
        };
      };
    };
  };

  testScript = ''
    def switch_to_tty(tty_number):
      machine.fail(f"pgrep -f 'agetty.*tty{tty_number}'")
      machine.send_key(f"alt-f{tty_number}")
      machine.wait_until_succeeds(f"[ $(fgconsole) = {tty_number} ]")
      machine.wait_for_unit(f"getty@tty{tty_number}.service")
      machine.wait_until_succeeds(f"pgrep -f 'agetty.*tty{tty_number}'")


    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("getty@tty1.service")

    with subtest("${alice} cannot login"):
      machine.wait_until_tty_matches("1", "login: ")
      machine.send_chars("${alice}\n")
      machine.wait_until_tty_matches("1", "Password: ")
      machine.send_chars("${passwd}\n")

      machine.wait_until_succeeds("journalctl --grep='account ${alice} has expired \\(account expired\\)'")
      machine.wait_until_tty_matches("1", "login: ")

    with subtest("${bob} can login"):
      switch_to_tty(2)
      machine.wait_until_tty_matches("2", "login: ")
      machine.send_chars("${bob}\n")
      machine.wait_until_tty_matches("2", "Password: ")
      machine.send_chars("${passwd}\n")

      machine.wait_until_succeeds("pgrep -u ${bob} bash")

    with subtest("${eve} can login"):
      switch_to_tty(3)
      machine.wait_until_tty_matches("3", "login: ")
      machine.send_chars("${eve}\n")
      machine.wait_until_tty_matches("3", "Password: ")
      machine.send_chars("${passwd}\n")

      machine.wait_until_succeeds("pgrep -u ${eve} bash")
  '';
}

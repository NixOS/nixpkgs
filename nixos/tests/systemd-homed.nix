import ./make-test-python.nix ({ pkgs, lib, ... }:
let
  password = "foobarfoo";
  newPass = "barfoobar";
in
{
  name = "systemd-homed";
  nodes.machine = { config, pkgs, ... }: {
    services.homed.enable = true;

    users.users.test-normal-user = {
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      initialPassword = password;
    };
  };
  testScript = ''
    def switchTTY(number):
      machine.send_key(f"alt-f{number}")
      machine.wait_until_succeeds(f"[ $(fgconsole) = {number} ]")
      machine.wait_for_unit(f"getty@tty{number}.service")
      machine.wait_until_succeeds(f"pgrep -f 'agetty.*tty{number}'")

    machine.wait_for_unit("multi-user.target")

    # Smoke test to make sure the pam changes didn't break regular users.
    machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
    with subtest("login as regular user"):
      switchTTY(2)
      machine.wait_until_tty_matches("2", "login: ")
      machine.send_chars("test-normal-user\n")
      machine.wait_until_tty_matches("2", "login: test-normal-user")
      machine.wait_until_tty_matches("2", "Password: ")
      machine.send_chars("${password}\n")
      machine.wait_until_succeeds("pgrep -u test-normal-user bash")
      machine.send_chars("whoami > /tmp/1\n")
      machine.wait_for_file("/tmp/1")
      assert "test-normal-user" in machine.succeed("cat /tmp/1")

    with subtest("create homed encrypted user"):
      # TODO: Figure out how to pass password manually.
      #
      # This environment variable is used for homed internal testing
      # and is not documented.
      machine.succeed("NEWPASSWORD=${password} homectl create --shell=/run/current-system/sw/bin/bash --storage=luks -G wheel test-homed-user")

    with subtest("login as homed user"):
      switchTTY(3)
      machine.wait_until_tty_matches("3", "login: ")
      machine.send_chars("test-homed-user\n")
      machine.wait_until_tty_matches("3", "login: test-homed-user")
      machine.wait_until_tty_matches("3", "Password: ")
      machine.send_chars("${password}\n")
      machine.wait_until_succeeds("pgrep -t tty3 -u test-homed-user bash")
      machine.send_chars("whoami > /tmp/2\n")
      machine.wait_for_file("/tmp/2")
      assert "test-homed-user" in machine.succeed("cat /tmp/2")

    with subtest("change homed user password"):
      switchTTY(4)
      machine.wait_until_tty_matches("4", "login: ")
      machine.send_chars("test-homed-user\n")
      machine.wait_until_tty_matches("4", "login: test-homed-user")
      machine.wait_until_tty_matches("4", "Password: ")
      machine.send_chars("${password}\n")
      machine.wait_until_succeeds("pgrep -t tty4 -u test-homed-user bash")
      machine.send_chars("passwd\n")
      # homed does it in a weird order, it asks for new passes, then it asks
      # for the old one.
      machine.sleep(2)
      machine.send_chars("${newPass}\n")
      machine.sleep(2)
      machine.send_chars("${newPass}\n")
      machine.sleep(4)
      machine.send_chars("${password}\n")
      machine.wait_until_fails("pgrep -t tty4 passwd")

      @polling_condition
      def not_logged_in_tty5():
        machine.fail("pgrep -t tty5 bash")

      switchTTY(5)
      with not_logged_in_tty5: # type: ignore[union-attr]
        machine.wait_until_tty_matches("5", "login: ")
        machine.send_chars("test-homed-user\n")
        machine.wait_until_tty_matches("5", "login: test-homed-user")
        machine.wait_until_tty_matches("5", "Password: ")
        machine.send_chars("${password}\n")
        machine.wait_until_tty_matches("5", "Password incorrect or not sufficient for authentication of user test-homed-user.")
        machine.wait_until_tty_matches("5", "Sorry, try again: ")
      machine.send_chars("${newPass}\n")
      machine.send_chars("whoami > /tmp/4\n")
      machine.wait_for_file("/tmp/4")
      assert "test-homed-user" in machine.succeed("cat /tmp/4")

    with subtest("homed user should be in wheel according to NSS"):
      machine.succeed("userdbctl group wheel -s io.systemd.NameServiceSwitch | grep test-homed-user")
  '';
})

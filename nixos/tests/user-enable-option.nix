let
  normal-enabled = "username-normal-enabled";
  normal-disabled = "username-normal-disabled";
  system-enabled = "username-system-enabled";
  system-disabled = "username-system-disabled";
  passwd = "enableOptionPasswd";
in
{
  name = "user-enable-option";

  nodes.machine = {
    users = {
      groups.test-group = { };
      users = {
        # User is enabled (default behaviour).
        ${normal-enabled} = {
          enable = true;
          isNormalUser = true;
          initialPassword = passwd;
        };

        # User is disabled.
        ${normal-disabled} = {
          enable = false;
          isNormalUser = true;
          initialPassword = passwd;
        };

        # User is a system user, and is enabled.
        ${system-enabled} = {
          enable = true;
          isSystemUser = true;
          initialPassword = passwd;
          group = "test-group";
        };

        # User is a system user, and is disabled.
        ${system-disabled} = {
          enable = false;
          isSystemUser = true;
          initialPassword = passwd;
          group = "test-group";
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

    with subtest("${normal-enabled} exists"):
        check_fn = "id ${normal-enabled}"
        machine.succeed(check_fn)
        machine.wait_until_tty_matches("1", "login: ")
        machine.send_chars("${normal-enabled}\n")
        machine.wait_until_tty_matches("1", "Password: ")
        machine.send_chars("${passwd}\n")

    with subtest("${normal-disabled} does not exist"):
        switch_to_tty(2)
        check_fn = "id ${normal-disabled}"
        machine.fail(check_fn)

    with subtest("${system-enabled} exists"):
        switch_to_tty(3)
        check_fn = "id ${system-enabled}"
        machine.succeed(check_fn)

    with subtest("${system-disabled} does not exist"):
        switch_to_tty(4)
        check_fn = "id ${system-disabled}"
        machine.fail(check_fn)
  '';
}

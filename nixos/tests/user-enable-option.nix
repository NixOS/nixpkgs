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
    def check_user(username, status):
      check_fn = f"id {username}"
      if status == "success":
        machine.succeed(check_fn)
      elif status == "fail":
        machine.fail(check_fn)

    def switch_to_tty(tty_number):
      machine.fail(f"pgrep -f 'agetty.*tty{tty_number}'")
      machine.send_key(f"alt-f{tty_number}")
      machine.wait_until_succeeds(f"[ $(fgconsole) = {tty_number} ]")
      machine.wait_for_unit(f"getty@tty{tty_number}.service")
      machine.wait_until_succeeds(f"pgrep -f 'agetty.*tty{tty_number}'")

    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("getty@tty1.service")

    with subtest("${normal-enabled} exists"):
      check_user("${normal-enabled}", "success")
      machine.wait_until_tty_matches("1", "login: ")
      machine.send_chars("${normal-enabled}\n")
      machine.wait_until_tty_matches("1", "Password: ")
      machine.send_chars("${passwd}\n")

    with subtest("${normal-disabled} does not exist"):
      switch_to_tty(2)
      check_user("${normal-disabled}", "fail")

    with subtest("${system-enabled} exists"):
      switch_to_tty(3)
      check_user("${system-enabled}", "success")

    with subtest("${system-disabled} does not exist"):
      switch_to_tty(4)
      check_user("${system-disabled}", "fail")
  '';
}

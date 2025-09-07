let
  username = "test-homed-user";
  initialPassword = "foobarfoo";
  newPassword = "barfoobar";
in

{
  name = "systemd-homed";

  nodes = {
    machine =
      { ... }:
      {
        services = {
          homed.enable = true;
          openssh.enable = true;
        };

        # Prevent nixbld users from showing up as regular users, required for
        # first boot prompt
        nix.settings = {
          experimental-features = [ "auto-allocate-uids" ];
          auto-allocate-uids = true;
        };
      };

    sshClient =
      { pkgs, ... }:
      {
        services = {
          homed.enable = true;
          userdbd.silenceHighSystemUsers = true;
        };

        # Regular user, should prevent first boot prompt
        users.users.test-normal-user = {
          extraGroups = [ "wheel" ];
          isNormalUser = true;
          inherit initialPassword;
        };
      };
  };

  testScript = ''
    start_all()

    with subtest("create systemd-homed user on first boot prompt"):
      machine.wait_for_unit("systemd-homed.service")
      machine.wait_until_tty_matches("1", "-- Press any key to proceed --")
      machine.send_chars(" ")
      machine.wait_until_tty_matches("1", "Please enter user name")
      machine.send_chars("${username}\n")
      machine.wait_until_tty_matches("1", "Please enter an auxiliary group")
      machine.send_chars("wheel\n")
      machine.wait_until_tty_matches("1", "Please enter an auxiliary group")
      machine.send_chars("\n")
      machine.wait_until_tty_matches("1", "Please enter the shell to use")
      machine.send_chars("/bin/sh\n")
      machine.wait_until_tty_matches("1", "Please enter new password")
      machine.send_chars("${initialPassword}\n")
      machine.wait_until_tty_matches("1", "(repeat)")
      machine.send_chars("${initialPassword}\n")

    with subtest("login as homed user"):
      machine.wait_until_tty_matches("1", "login: ")
      machine.send_chars("${username}\n")
      machine.wait_until_tty_matches("1", "Password: ")
      machine.send_chars("${initialPassword}\n")
      machine.wait_until_succeeds("pgrep -u ${username} -t tty1 sh")
      machine.send_chars("whoami > /tmp/2\n")
      machine.wait_for_file("/tmp/2")
      assert "${username}" in machine.succeed("cat /tmp/2")

    # Smoke test to make sure the pam changes didn't break regular users.
    # Since homed is also enabled in the sshClient, it also tests the first
    # boot prompt did not occur.
    with subtest("login as regular user"):
      sshClient.wait_until_tty_matches("1", "login: ")
      sshClient.send_chars("test-normal-user\n")
      sshClient.wait_until_tty_matches("1", "Password: ")
      sshClient.send_chars("${initialPassword}\n")
      sshClient.wait_until_succeeds("pgrep -u test-normal-user bash")
      sshClient.send_chars("whoami > /tmp/1\n")
      sshClient.wait_for_file("/tmp/1")
      assert "test-normal-user" in sshClient.succeed("cat /tmp/1")

    with subtest("add homed ssh authorized key"):
      sshClient.send_chars('ssh-keygen -t ed25519 -f /tmp/id_ed25519 -N ""\n')
      sshClient.wait_for_file("/tmp/id_ed25519.pub")
      public_key = sshClient.succeed('cat /tmp/id_ed25519.pub')
      public_key = public_key.strip()
      machine.succeed(f"homectl update ${username} --offline --ssh-authorized-keys '{public_key}'")
      machine.succeed("userdbctl ssh-authorized-keys ${username} | grep ed25519")

    with subtest("change homed user password"):
      machine.send_chars("passwd; echo $? > /tmp/3\n")
      # homed does it in a weird order, it asks for new passes, then it asks
      # for the old one.
      machine.wait_until_tty_matches("1", "New password: ")
      machine.send_chars("${newPassword}\n")
      machine.wait_until_tty_matches("1", "Retype new password: ")
      machine.send_chars("${newPassword}\n")
      #machine.wait_until_tty_matches("1", "Password: ")
      machine.sleep(4)
      machine.send_chars("${initialPassword}\n")
      machine.wait_for_file("/tmp/3")
      assert "0\n" == machine.succeed("cat /tmp/3")

    with subtest("escalate to root from homed user"):
      # Also tests the user is in wheel.
      machine.send_chars("sudo id | tee /tmp/4\n")
      machine.wait_until_tty_matches("1", "password for ${username}")
      machine.send_chars("${newPassword}\n")
      machine.wait_for_file("/tmp/4")
      machine.wait_until_succeeds("grep uid=0 /tmp/4")

    with subtest("log out and deactivate homed user's home area"):
      machine.send_chars("exit\n")
      machine.wait_until_succeeds("homectl inspect ${username} | grep 'State: inactive'")

    with subtest("ssh as homed user"):
      sshClient.send_chars("ssh -o StrictHostKeyChecking=no -i /tmp/id_ed25519 ${username}@machine\n")
      sshClient.wait_until_tty_matches("1", "Please enter password for user")
      sshClient.send_chars("${newPassword}\n")
      machine.wait_until_succeeds("pgrep -u ${username} sh")
      sshClient.send_chars("whoami > /tmp/5\n")
      machine.wait_for_file("/tmp/5")
      assert "${username}" in machine.succeed("cat /tmp/5")
      sshClient.send_chars("exit\n") # ssh
      sshClient.send_chars("exit\n") # sh
  '';
}

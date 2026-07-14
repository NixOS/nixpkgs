{
  name = "login-nosuid";
  meta = {
    maintainers = [ ];
  };

  # node.pkgsReadOnly = false; # needed when overriding pam to debug mode

  nodes.machine =
    { pkgs, ... }:
    {
      security.enableWrappers = false;
      systemd.settings.Manager.NoNewPrivileges = true;
      security.account-utils.enable = true;
      users.mutableUsers = true;
      security.account-utils.extraArgs = [
        "-v"
        "--debug"
      ];
      security.loginDefs.chfnRestrict = "f"; # allow allice to change name

      environment.systemPackages = [
        pkgs.which
        pkgs.fish # environment.shells does not actually link fish to /run/current-system/sw/bin, causing chsh to fail unexpectedly
      ];
      environment.shells = [ pkgs.fish ];

      # pam debug without giant rebuild
      # system.replaceDependencies.replacements = [
      #   {
      #     oldDependency = pkgs.linux-pam;
      #     newDependency = pkgs.linux-pam.override { debugMode = true; };
      #   }
      # ];
    };

  testScript = ''
    machine.start(allow_reboot = True)

    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
    machine.screenshot("postboot")

    with subtest("account-utils passwd has priority"):
        passwd_path = machine.succeed("realpath $(which passwd)")
        print(f"passwd path is: {passwd_path}")
        assert "account-utils" in passwd_path

    with subtest("create user"):
        machine.succeed("useradd -m alice")
        machine.succeed("(echo foobar; echo foobar) | passwd alice")

    with subtest("Check whether switching VTs works"):
        machine.fail("pgrep -f 'agetty.*tty2'")
        machine.send_key("alt-f2")
        machine.wait_until_succeeds("[ $(fgconsole) = 2 ]")
        machine.wait_for_unit("getty@tty2.service")
        machine.wait_until_succeeds("pgrep -f 'agetty.*tty2'")

    with subtest("Log in as alice on a virtual console"):
        machine.wait_until_tty_matches("2", "login: ")
        machine.send_chars("alice\n")
        machine.wait_until_tty_matches("2", "login: alice")
        machine.wait_until_succeeds("pgrep login")
        machine.wait_until_tty_matches("2", "Password: ")
        machine.sleep(1) # something is racy here, so lets just sleep a bit... Not great, but seems to work
        machine.send_chars("foobar\n")
        machine.wait_until_succeeds("pgrep -u alice bash")
        machine.send_chars("touch done\n")
        machine.wait_for_file("/home/alice/done")

    with subtest("Systemd gives and removes device ownership as needed"):
        machine.succeed("getfacl /dev/snd/timer | grep -q alice")
        machine.send_key("alt-f1")
        machine.wait_until_succeeds("[ $(fgconsole) = 1 ]")
        machine.fail("getfacl /dev/snd/timer | grep -q alice")
        machine.succeed("chvt 2")
        machine.wait_until_succeeds("getfacl /dev/snd/timer | grep -q alice")

    with subtest("User can change their login shell"):
        machine.send_chars("clear\n") # remove previous password prompts
        machine.send_chars("chsh -s /run/current-system/sw/bin/fish\n")
        machine.wait_until_tty_matches("2", "Password: ")
        machine.send_chars("foobar\n")
        machine.wait_until_fails("pgrep pwupdd")
        login_shell = machine.succeed("getent passwd alice | cut -d: -f7").strip()
        print(f"login shell of user alice: {login_shell}")
        assert "/run/current-system/sw/bin/fish" == login_shell

    with subtest("User can change their name"):
        machine.send_chars("clear\n") # remove previous password prompts
        machine.send_chars("chfn -f 'Alice in Wonderland'\n")
        machine.wait_until_tty_matches("2", "Password: ")
        machine.send_chars("foobar\n")
        machine.wait_until_fails("pgrep pwupdd")
        full_name = machine.succeed("getent passwd alice | cut -d: -f5").strip()
        print(f"full name of user alice: {full_name}")
        assert "Alice in Wonderland" == full_name

    with subtest("Virtual console logout"):
        machine.send_chars("exit\n")
        machine.wait_until_fails("pgrep -u alice bash")
        machine.screenshot("getty")
  '';
}

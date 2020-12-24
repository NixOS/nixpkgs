let
  password1 = "foobar";
  password2 = "helloworld";
  password3 = "bazqux";
in import ./make-test-python.nix ({ pkgs, ... }: {
  name = "shadow";
  meta = with pkgs.stdenv.lib.maintainers; { maintainers = [ nequissimus ]; };

  nodes.shadow = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.shadow ];

    users = {
      mutableUsers = true;
      users.emma = {
        password = password1;
        shell = pkgs.bash;
      };
      users.layla = {
        password = password2;
        shell = pkgs.shadow;
      };
    };
  };

  testScript = ''
    shadow.wait_for_unit("multi-user.target")
    shadow.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

    with subtest("Normal login"):
        shadow.send_key("alt-f2")
        shadow.wait_until_succeeds(f"[ $(fgconsole) = 2 ]")
        shadow.wait_for_unit(f"getty@tty2.service")
        shadow.wait_until_succeeds(f"pgrep -f 'agetty.*tty2'")
        shadow.wait_until_tty_matches(2, "login: ")
        shadow.send_chars("emma\n")
        shadow.wait_until_tty_matches(2, "login: emma")
        shadow.wait_until_succeeds("pgrep login")
        shadow.sleep(2)
        shadow.send_chars("${password1}\n")
        shadow.send_chars("whoami > /tmp/1\n")
        shadow.wait_for_file("/tmp/1")
        assert "emma" in shadow.succeed("cat /tmp/1")

    with subtest("Change password"):
        shadow.send_key("alt-f3")
        shadow.wait_until_succeeds(f"[ $(fgconsole) = 3 ]")
        shadow.wait_for_unit(f"getty@tty3.service")
        shadow.wait_until_succeeds(f"pgrep -f 'agetty.*tty3'")
        shadow.wait_until_tty_matches(3, "login: ")
        shadow.send_chars("emma\n")
        shadow.wait_until_tty_matches(3, "login: emma")
        shadow.wait_until_succeeds("pgrep login")
        shadow.sleep(2)
        shadow.send_chars("${password1}\n")
        shadow.send_chars("passwd\n")
        shadow.sleep(2)
        shadow.send_chars("${password1}\n")
        shadow.sleep(2)
        shadow.send_chars("${password3}\n")
        shadow.sleep(2)
        shadow.send_chars("${password3}\n")
        shadow.sleep(2)
        shadow.send_key("alt-f4")
        shadow.wait_until_succeeds(f"[ $(fgconsole) = 4 ]")
        shadow.wait_for_unit(f"getty@tty4.service")
        shadow.wait_until_succeeds(f"pgrep -f 'agetty.*tty4'")
        shadow.wait_until_tty_matches(4, "login: ")
        shadow.send_chars("emma\n")
        shadow.wait_until_tty_matches(4, "login: emma")
        shadow.wait_until_succeeds("pgrep login")
        shadow.sleep(2)
        shadow.send_chars("${password1}\n")
        shadow.wait_until_tty_matches(4, "Login incorrect")
        shadow.wait_until_tty_matches(4, "login:")
        shadow.send_chars("emma\n")
        shadow.wait_until_tty_matches(4, "login: emma")
        shadow.wait_until_succeeds("pgrep login")
        shadow.sleep(2)
        shadow.send_chars("${password3}\n")
        shadow.send_chars("whoami > /tmp/2\n")
        shadow.wait_for_file("/tmp/2")
        assert "emma" in shadow.succeed("cat /tmp/2")

    with subtest("Groups"):
        assert "foobar" not in shadow.succeed("groups emma")
        shadow.succeed("groupadd foobar")
        shadow.succeed("usermod -a -G foobar emma")
        assert "foobar" in shadow.succeed("groups emma")

    with subtest("nologin shell"):
        shadow.send_key("alt-f5")
        shadow.wait_until_succeeds(f"[ $(fgconsole) = 5 ]")
        shadow.wait_for_unit(f"getty@tty5.service")
        shadow.wait_until_succeeds(f"pgrep -f 'agetty.*tty5'")
        shadow.wait_until_tty_matches(5, "login: ")
        shadow.send_chars("layla\n")
        shadow.wait_until_tty_matches(5, "login: layla")
        shadow.wait_until_succeeds("pgrep login")
        shadow.send_chars("${password2}\n")
        shadow.wait_until_tty_matches(5, "login:")
  '';
})

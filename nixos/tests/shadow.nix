let
  password1 = "foobar";
  password2 = "helloworld";
  password3 = "bazqux";
  password4 = "asdf123";
  hashed_bcrypt = "$2b$05$8xIEflrk2RxQtcVXbGIxs.Vl0x7dF1/JSv3cyX6JJt0npzkTCWvxK"; # fnord
  hashed_yeshash = "$y$j9T$d8Z4EAf8P1SvM/aDFbxMS0$VnTXMp/Hnc7QdCBEaLTq5ZFOAFo2/PM0/xEAFuOE88."; # fnord
  hashed_sha512crypt = "$6$ymzs8WINZ5wGwQcV$VC2S0cQiX8NVukOLymysTPn4v1zJoJp3NGyhnqyv/dAf4NWZsBWYveQcj6gEJr4ZUjRBRjM0Pj1L8TCQ8hUUp0"; # meow
in import ./make-test-python.nix ({ pkgs, ... }: {
  name = "shadow";
  meta = with pkgs.lib.maintainers; { maintainers = [ nequissimus ]; };

  nodes.shadow = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.shadow ];

    users = {
      mutableUsers = true;
      users.emma = {
        isNormalUser = true;
        password = password1;
        shell = pkgs.bash;
      };
      users.layla = {
        isNormalUser = true;
        password = password2;
        shell = pkgs.shadow;
      };
      users.ash = {
        isNormalUser = true;
        password = password4;
        shell = pkgs.bash;
      };
      users.berta = {
        isNormalUser = true;
        hashedPasswordFile = (pkgs.writeText "hashed_bcrypt" hashed_bcrypt).outPath;
        shell = pkgs.bash;
      };
      users.yesim = {
        isNormalUser = true;
        hashedPassword = hashed_yeshash;
        shell = pkgs.bash;
      };
      users.leo = {
        isNormalUser = true;
        initialHashedPassword = "!";
        hashedPassword = hashed_sha512crypt; # should take precedence over initialHashedPassword
        shell = pkgs.bash;
      };
    };
  };

  testScript = ''
    shadow.wait_for_unit("multi-user.target")
    shadow.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

    with subtest("Normal login"):
        shadow.send_key("alt-f2")
        shadow.wait_until_succeeds("[ $(fgconsole) = 2 ]")
        shadow.wait_for_unit("getty@tty2.service")
        shadow.wait_until_succeeds("pgrep -f 'agetty.*tty2'")
        shadow.wait_until_tty_matches("2", "login: ")
        shadow.send_chars("emma\n")
        shadow.wait_until_tty_matches("2", "login: emma")
        shadow.wait_until_succeeds("pgrep login")
        shadow.sleep(2)
        shadow.send_chars("${password1}\n")
        shadow.send_chars("whoami > /tmp/1\n")
        shadow.wait_for_file("/tmp/1")
        assert "emma" in shadow.succeed("cat /tmp/1")

    with subtest("Switch user"):
        shadow.send_chars("su - ash\n")
        shadow.sleep(2)
        shadow.send_chars("${password4}\n")
        shadow.sleep(2)
        shadow.send_chars("whoami > /tmp/3\n")
        shadow.wait_for_file("/tmp/3")
        assert "ash" in shadow.succeed("cat /tmp/3")

    with subtest("Change password"):
        shadow.send_key("alt-f3")
        shadow.wait_until_succeeds("[ $(fgconsole) = 3 ]")
        shadow.wait_for_unit("getty@tty3.service")
        shadow.wait_until_succeeds("pgrep -f 'agetty.*tty3'")
        shadow.wait_until_tty_matches("3", "login: ")
        shadow.send_chars("emma\n")
        shadow.wait_until_tty_matches("3", "login: emma")
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
        shadow.wait_until_succeeds("[ $(fgconsole) = 4 ]")
        shadow.wait_for_unit("getty@tty4.service")
        shadow.wait_until_succeeds("pgrep -f 'agetty.*tty4'")
        shadow.wait_until_tty_matches("4", "login: ")
        shadow.send_chars("emma\n")
        shadow.wait_until_tty_matches("4", "login: emma")
        shadow.wait_until_succeeds("pgrep login")
        shadow.sleep(2)
        shadow.send_chars("${password1}\n")
        shadow.wait_until_tty_matches("4", "Login incorrect")
        shadow.wait_until_tty_matches("4", "login:")
        shadow.send_chars("emma\n")
        shadow.wait_until_tty_matches("4", "login: emma")
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
        shadow.wait_until_succeeds("[ $(fgconsole) = 5 ]")
        shadow.wait_for_unit("getty@tty5.service")
        shadow.wait_until_succeeds("pgrep -f 'agetty.*tty5'")
        shadow.wait_until_tty_matches("5", "login: ")
        shadow.send_chars("layla\n")
        shadow.wait_until_tty_matches("5", "login: layla")
        shadow.wait_until_succeeds("pgrep login")
        shadow.send_chars("${password2}\n")
        shadow.wait_until_tty_matches("5", "login:")

    with subtest("check alternate password hashes"):
        shadow.send_key("alt-f6")
        shadow.wait_until_succeeds("[ $(fgconsole) = 6 ]")
        for u in ["berta", "yesim"]:
            shadow.wait_for_unit("getty@tty6.service")
            shadow.wait_until_succeeds("pgrep -f 'agetty.*tty6'")
            shadow.wait_until_tty_matches("6", "login: ")
            shadow.send_chars(f"{u}\n")
            shadow.wait_until_tty_matches("6", f"login: {u}")
            shadow.wait_until_succeeds("pgrep login")
            shadow.sleep(2)
            shadow.send_chars("fnord\n")
            shadow.send_chars(f"whoami > /tmp/{u}\n")
            shadow.wait_for_file(f"/tmp/{u}")
            print(shadow.succeed(f"cat /tmp/{u}"))
            assert u in shadow.succeed(f"cat /tmp/{u}")
            shadow.send_chars("logout\n")

    with subtest("Ensure hashedPassword does not get overridden by initialHashedPassword"):
        shadow.send_key("alt-f6")
        shadow.wait_until_succeeds("[ $(fgconsole) = 6 ]")
        shadow.wait_for_unit("getty@tty6.service")
        shadow.wait_until_succeeds("pgrep -f 'agetty.*tty6'")
        shadow.wait_until_tty_matches("6", "login: ")
        shadow.send_chars("leo\n")
        shadow.wait_until_tty_matches("6", "login: leo")
        shadow.wait_until_succeeds("pgrep login")
        shadow.sleep(2)
        shadow.send_chars("meow\n")
        shadow.send_chars("whoami > /tmp/leo\n")
        shadow.wait_for_file("/tmp/leo")
        assert "leo" in shadow.succeed("cat /tmp/leo")
        shadow.send_chars("logout\n")
  '';
})

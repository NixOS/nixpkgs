let
  password1 = "foobar";
  password2 = "helloworld";
  password3 = "bazqux";
  password4 = "asdf123";
  hashed_bcrypt = "$2b$05$8xIEflrk2RxQtcVXbGIxs.Vl0x7dF1/JSv3cyX6JJt0npzkTCWvxK"; # fnord
  hashed_yeshash = "$y$j9T$d8Z4EAf8P1SvM/aDFbxMS0$VnTXMp/Hnc7QdCBEaLTq5ZFOAFo2/PM0/xEAFuOE88."; # fnord
  hashed_sha512crypt = "$6$ymzs8WINZ5wGwQcV$VC2S0cQiX8NVukOLymysTPn4v1zJoJp3NGyhnqyv/dAf4NWZsBWYveQcj6gEJr4ZUjRBRjM0Pj1L8TCQ8hUUp0"; # meow
in
import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "password-option-override-ordering";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ fidgetingbits ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.shadow ];

        users = {
          mutableUsers = false;

          # NOTE: Below given A -> B it implies B overrides A . Each entry below builds off the next

          # initialHashedPassword -> hashedPassword
          users.fran = {
            isNormalUser = true;
            initialHashedPassword = hashed_yeshash;
            hashedPassword = hashed_sha512crypt;
          };

          # initialHashedPassword -> hashedPassword -> initialPassword
          users.greg = {
            isNormalUser = true;
            hashedPassword = hashed_sha512crypt;
            initialPassword = password1; # Expect override of above
          };

          # initialHashedPassword -> hashedPassword -> initialPassword -> password
          users.egon = {
            isNormalUser = true;
            initialPassword = password2;
            password = password1;
          };

          # initialHashedPassword -> hashedPassword -> initialPassword -> password
          # NOTE: duplication, but to verify no initialXXX use is consistent
          users.alice = {
            isNormalUser = true;
            hashedPassword = hashed_sha512crypt;
            password = password1;
          };

          # initialHashedPassword -> hashedPassword -> initialPassword -> password -> hashedPasswordFile
          users.bob = {
            isNormalUser = true;
            hashedPassword = hashed_sha512crypt;
            password = password1;
            hashedPasswordFile = (pkgs.writeText "hashed_bcrypt" hashed_bcrypt).outPath; # Expect override of everything above
          };

          # Show hashedPassword -> password -> hashedPasswordFile -> initialPassword is false
          # to explicitly show the following lib.trace warning in users-groups.nix is wrong:
          # ```
          # The user 'root' has multiple of the options
          # `hashedPassword`, `password`, `hashedPasswordFile`, `initialPassword`
          # & `initialHashedPassword` set to a non-null value.
          # The options silently discard others by the order of precedence
          # given above which can lead to surprising results. To resolve this warning,
          # set at most one of the options above to a non-`null` value.
          # ```
          users.cat = {
            isNormalUser = true;
            hashedPassword = hashed_sha512crypt;
            password = password1;
            hashedPasswordFile = (pkgs.writeText "hashed_bcrypt" hashed_bcrypt).outPath;
            initialPassword = password2; # lib.trace message implies this overrides everything above
          };

          # Show hashedPassword -> password -> hashedPasswordFile -> initialHashedPassword is false
          # to explicitly show the lib.trace shown above is wrong
          users.dan = {
            isNormalUser = true;
            hashedPassword = hashed_sha512crypt;
            initialPassword = password2;
            password = password1;
            hashedPasswordFile = (pkgs.writeText "hashed_bcrypt" hashed_bcrypt).outPath;
            initialHashedPassword = hashed_yeshash; # lib.trace message implies this overrides everything above
          };
        };
      };

    testScript = ''
      with subtest("alice user has correct password"):
        print(machine.succeed("getent passwd alice"))
        assert "${hashed_sha512crypt}" not in machine.succeed("getent shadow alice"), "alice user password is not correct"

      with subtest("bob user has correct password"):
        print(machine.succeed("getent passwd bob"))
        assert "${hashed_bcrypt}" in machine.succeed("getent shadow bob"), "bob user password is not correct"

      with subtest("cat user has correct password"):
        print(machine.succeed("getent passwd cat"))
        assert "${hashed_bcrypt}" in machine.succeed("getent shadow cat"), "cat user password is not correct"

      with subtest("dan user has correct password"):
        print(machine.succeed("getent passwd dan"))
        assert "${hashed_bcrypt}" in machine.succeed("getent shadow dan"), "dan user password is not correct"

      with subtest("greg user has correct password"):
        print(machine.succeed("getent passwd greg"))
        assert "${hashed_sha512crypt}" not in machine.succeed("getent shadow greg"), "greg user password is not correct"

      machine.wait_for_unit("multi-user.target")
      machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

      with subtest("Test initialPassword override"):
          machine.send_key("alt-f2")
          machine.wait_until_succeeds("[ $(fgconsole) = 2 ]")
          machine.wait_for_unit("getty@tty2.service")
          machine.wait_until_succeeds("pgrep -f 'agetty.*tty2'")
          machine.wait_until_tty_matches("2", "login: ")
          machine.send_chars("egon\n")
          machine.wait_until_tty_matches("2", "login: egon")
          machine.wait_until_succeeds("pgrep login")
          machine.sleep(2)
          machine.send_chars("${password1}\n")
          machine.send_chars("whoami > /tmp/1\n")
          machine.wait_for_file("/tmp/1")
          assert "egon" in machine.succeed("cat /tmp/1")

      with subtest("Test initialHashedPassword override"):
          machine.send_key("alt-f3")
          machine.wait_until_succeeds("[ $(fgconsole) = 3 ]")
          machine.wait_for_unit("getty@tty3.service")
          machine.wait_until_succeeds("pgrep -f 'agetty.*tty3'")
          machine.wait_until_tty_matches("3", "login: ")
          machine.send_chars("fran\n")
          machine.wait_until_tty_matches("3", "login: fran")
          machine.wait_until_succeeds("pgrep login")
          machine.sleep(2)
          machine.send_chars("meow\n")
          machine.send_chars("whoami > /tmp/3\n")
          machine.wait_for_file("/tmp/3")
          assert "fran" in machine.succeed("cat /tmp/3")
    '';
  }
)

let
  password1 = "foobar";
  password2 = "helloworld";
  hashed_bcrypt = "$2b$05$8xIEflrk2RxQtcVXbGIxs.Vl0x7dF1/JSv3cyX6JJt0npzkTCWvxK"; # fnord
  hashed_yeshash = "$y$j9T$d8Z4EAf8P1SvM/aDFbxMS0$VnTXMp/Hnc7QdCBEaLTq5ZFOAFo2/PM0/xEAFuOE88."; # fnord
  hashed_sha512crypt = "$6$ymzs8WINZ5wGwQcV$VC2S0cQiX8NVukOLymysTPn4v1zJoJp3NGyhnqyv/dAf4NWZsBWYveQcj6gEJr4ZUjRBRjM0Pj1L8TCQ8hUUp0"; # meow
in

{ pkgs, ... }:
{
  name = "password-option-override-ordering";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fidgetingbits ];
  };

  nodes =
    let
      # The following users are expected to have the same behavior between immutable and mutable systems
      # NOTE: Below given A -> B it implies B overrides A . Each entry below builds off the next
      users = {
        # mutable true/false: initialHashedPassword -> hashedPassword
        fran = {
          isNormalUser = true;
          initialHashedPassword = hashed_yeshash;
          hashedPassword = hashed_sha512crypt;
        };

        # mutable false: initialHashedPassword -> hashedPassword -> initialPassword
        # mutable true: initialHashedPassword -> initialPassword -> hashedPassword
        greg = {
          isNormalUser = true;
          hashedPassword = hashed_sha512crypt;
          initialPassword = password1;
        };

        # mutable false: initialHashedPassword -> hashedPassword -> initialPassword -> password
        # mutable true: initialHashedPassword -> initialPassword -> hashedPassword -> password
        egon = {
          isNormalUser = true;
          initialPassword = password2;
          password = password1;
        };

        # mutable true/false: hashedPassword -> password
        # NOTE: minor duplication of test above, but to verify no initialXXX use is consistent
        alice = {
          isNormalUser = true;
          hashedPassword = hashed_sha512crypt;
          password = password1;
        };

        # mutable false: initialHashedPassword -> hashedPassword -> initialPassword -> password -> hashedPasswordFile
        # mutable true: initialHashedPassword -> initialPassword -> hashedPassword -> password -> hashedPasswordFile
        bob = {
          isNormalUser = true;
          hashedPassword = hashed_sha512crypt;
          password = password1;
          hashedPasswordFile = (pkgs.writeText "hashed_bcrypt" hashed_bcrypt).outPath; # Expect override of everything above
        };

        # Show hashedPassword -> password -> hashedPasswordFile -> initialPassword is false
        # to explicitly show the following lib.trace warning in users-groups.nix (which was
        # the wording prior to PR 310484) is in fact wrong:
        # ```
        # The user 'root' has multiple of the options
        # `hashedPassword`, `password`, `hashedPasswordFile`, `initialPassword`
        # & `initialHashedPassword` set to a non-null value.
        # The options silently discard others by the order of precedence
        # given above which can lead to surprising results. To resolve this warning,
        # set at most one of the options above to a non-`null` value.
        # ```
        cat = {
          isNormalUser = true;
          hashedPassword = hashed_sha512crypt;
          password = password1;
          hashedPasswordFile = (pkgs.writeText "hashed_bcrypt" hashed_bcrypt).outPath;
          initialPassword = password2; # lib.trace message implies this overrides everything above
        };

        # Show hashedPassword -> password -> hashedPasswordFile -> initialHashedPassword is false
        # to also explicitly show the lib.trace explained above (see cat user) is wrong
        dan = {
          isNormalUser = true;
          hashedPassword = hashed_sha512crypt;
          initialPassword = password2;
          password = password1;
          hashedPasswordFile = (pkgs.writeText "hashed_bcrypt" hashed_bcrypt).outPath;
          initialHashedPassword = hashed_yeshash; # lib.trace message implies this overrides everything above
        };
      };

      mkTestMachine = mutable: {
        environment.systemPackages = [ pkgs.shadow ];
        users = {
          mutableUsers = mutable;
          inherit users;
        };
      };
    in
    {
      immutable = mkTestMachine false;
      mutable = mkTestMachine true;
    };

  testScript = ''
    def assert_password_sha512crypt_match(machine, username, password):
      shadow_entry = machine.succeed(f"getent shadow {username}")
      print(shadow_entry)
      stored_hash = shadow_entry.split(":")[1]
      salt = stored_hash.split("$")[2]
      pass_hash = machine.succeed(f"mkpasswd -m sha512crypt {password} {salt}").strip()
      assert stored_hash == pass_hash, f"{username} user password does not match"

    with subtest("alice user has correct password"):
      for machine in machines:
        assert_password_sha512crypt_match(machine, "alice", "${password1}")
        assert "${hashed_sha512crypt}" not in machine.succeed("getent shadow alice"), f"{machine}: alice user password is not correct"

    with subtest("bob user has correct password"):
      for machine in machines:
        print(machine.succeed("getent shadow bob"))
        assert "${hashed_bcrypt}" in machine.succeed("getent shadow bob"), f"{machine}: bob user password is not correct"

    with subtest("cat user has correct password"):
      for machine in machines:
        print(machine.succeed("getent shadow cat"))
        assert "${hashed_bcrypt}" in machine.succeed("getent shadow cat"), f"{machine}: cat user password is not correct"

    with subtest("dan user has correct password"):
      for machine in machines:
        print(machine.succeed("getent shadow dan"))
        assert "${hashed_bcrypt}" in machine.succeed("getent shadow dan"), f"{machine}: dan user password is not correct"

    with subtest("greg user has correct password"):
      print(mutable.succeed("getent shadow greg"))
      assert "${hashed_sha512crypt}" in mutable.succeed("getent shadow greg"), "greg user password is not correct"

      assert_password_sha512crypt_match(immutable, "greg", "${password1}")
      assert "${hashed_sha512crypt}" not in immutable.succeed("getent shadow greg"), "greg user password is not correct"

    for machine in machines:
      machine.wait_for_unit("multi-user.target")
      machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

    def check_login(machine: Machine, tty_number: str, username: str, password: str):
      machine.send_key(f"alt-f{tty_number}")
      machine.wait_until_succeeds(f"[ $(fgconsole) = {tty_number} ]")
      machine.wait_for_unit(f"getty@tty{tty_number}.service")
      machine.wait_until_succeeds(f"pgrep -f 'agetty.*tty{tty_number}'")
      machine.wait_until_tty_matches(tty_number, "login: ")
      machine.send_chars(f"{username}\n")
      machine.wait_until_tty_matches(tty_number, f"login: {username}")
      machine.wait_until_succeeds("pgrep login")
      machine.wait_until_tty_matches(tty_number, "Password: ")
      machine.send_chars(f"{password}\n")
      machine.send_chars(f"whoami > /tmp/{tty_number}\n")
      machine.wait_for_file(f"/tmp/{tty_number}")
      assert username in machine.succeed(f"cat /tmp/{tty_number}"), f"{machine}: {username} password is not correct"

    with subtest("Test initialPassword override"):
      for machine in machines:
        check_login(machine, "2", "egon", "${password1}")

    with subtest("Test initialHashedPassword override"):
      for machine in machines:
        check_login(machine, "3", "fran", "meow")
  '';
}

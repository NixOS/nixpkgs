{ lib, ... }:
let
  # matches settings in pwquality format unit tests, keep in sync
  settings = {
    minlen = 10;

    # require each class: lowercase uppercase digit and symbol/other
    minclass = 4;

    badwords = [
      "foobar"
      "hunter42"
      "password"
    ];

    enforce_for_root = true;
  };
in
{
  name = "pam-pwquality";

  nodes.machine = {
    security.pam.pwquality = {
      enable = true;
      inherit settings;
    };
  };

  nodes.machine_global_conf = {
    security.pwquality = {
      writeGlobalSettings = true;
      inherit settings;
    };
  };

  # only runs when entering a new password so not necessary to test login with
  # existing password that violates rules
  testScript = ''
    import re

    # Helper functions

    def expect_contains(cmdOut, expectedOut):
      assert (expectedOut in cmdOut), f"\nExpected:\n{expectedOut}\nWithin:\n{cmdOut}"

    def login_as_alice(pw):
      machine.wait_until_tty_matches(1, "login: ")
      machine.send_chars("alice\n")
      machine.wait_until_tty_matches(1, "Password: ")
      machine.send_chars(f"{pw}\n")
      machine.wait_until_tty_matches(1, r"alice\@machine")


    def logout():
      machine.send_chars("logout\n")
      machine.wait_until_tty_matches(1, "login: ")

    gen_change_pw_command = lambda pw: f"(echo '{pw}'; echo '{pw}') | passwd alice 2>&1"
    test_change_pw_succeed = lambda pw: machine.succeed(gen_change_pw_command(pw))
    test_change_pw_fail = lambda pw: machine.fail(gen_change_pw_command(pw))


    # Consts

    short_password_error = "BAD PASSWORD: The password is shorter than 10 characters"
    missing_class_error = "BAD PASSWORD: The password contains less than 4 character classes"
    banned_word_error = "BAD PASSWORD: The password contains forbidden words in some form"
    password_change_success = "password updated successfully"

    pwquality_conf = "/etc/security/pwquality.conf"

    # "fake" passwords purely for testing
    # if these are your passwords please change them :)
    pw = "aB2$Nk4AW2"
    long_pw = "Nk4AW2wDkrXgcrNftdpKHpwqkRff7db@!96ubQCf-4H2q!d@9vP_EzAt@p*W*QqP"

    minlen = ${toString settings.minlen}
    banned_words = [ ${lib.concatStringsSep ", " (builtins.map (str: "\"${str}\"") settings.badwords)} ]


    # Testing
    machine_global_conf.wait_for_unit("multi-user.target")
    with subtest(f"{pwquality_conf} is configured as expected"):
      machine_global_conf.succeed(f"egrep '^minlen = {minlen}$' {pwquality_conf}")
      machine_global_conf.succeed(f"egrep '^enforce_for_root$' {pwquality_conf}")
      print(machine_global_conf.succeed(f"cat {pwquality_conf}"))
      for banned_word in banned_words:
        machine_global_conf.succeed(rf"egrep '^badwords =.*\s{banned_word}(\s.*|$)$' {pwquality_conf}")

    machine.wait_for_unit("multi-user.target")
    machine.succeed("useradd -m alice")

    with subtest("/etc/pam.d is configured as expected"):
      machine.succeed("egrep 'password required .*/lib/security/pam_pwquality.so' /etc/pam.d/ -R")


    with subtest("Test configuring passwords"):
      with subtest("Fail with complex but short password"):
        # good password shortened
        expect_contains(test_change_pw_fail(pw[:9]), short_password_error)

      with subtest("Fail with missing character type"):
        with subtest("No lowercase"):
          # good password all upper
          expect_contains(test_change_pw_fail(pw.upper()), missing_class_error)
        with subtest("No uppercase"):
          # good password all lower
          expect_contains(test_change_pw_fail(pw.lower()), missing_class_error)
        with subtest("No digits"):
          # good password no digets
          expect_contains(test_change_pw_fail(re.sub(r"\d", "Z", pw)), missing_class_error)
        with subtest("No symbols"):
          # good password no symbols
          expect_contains(test_change_pw_fail(pw.replace("$", "Z")), missing_class_error)

      with subtest("Fail with banned words"):
        for banned_word in banned_words:
          expect_contains(test_change_pw_fail(pw + banned_word), banned_word_error)
          expect_contains(test_change_pw_fail(banned_word + pw), banned_word_error)
          expect_contains(test_change_pw_fail(pw[:5] + banned_word + pw[5:]), banned_word_error)

      with subtest("Pass with sufficient passwords"):
        expect_contains(test_change_pw_succeed(pw), password_change_success)
        login_as_alice(pw)
        logout()

        expect_contains(test_change_pw_succeed(long_pw), password_change_success)
        login_as_alice(long_pw)
        logout()

  '';
}

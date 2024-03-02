import ../make-test-python.nix ({ ... }:

let
  oathSnakeoilSecret = "cdd4083ef8ff1fa9178c6d46bfb1a3";

  # With HOTP mode the password is calculated based on a counter of
  # how many passwords have been made. In this env, we'll always be on
  # the 0th counter, so the password is static.
  #
  # Generated in nix-shell -p oath-toolkit
  # via: oathtool -v -d6 -w10 cdd4083ef8ff1fa9178c6d46bfb1a3
  # and picking a the first 4:
  oathSnakeOilPassword1 = "143349";
  oathSnakeOilPassword2 = "801753";

  alicePassword = "foobar";
  # Generated via: mkpasswd -m sha-512 and passing in "foobar"
  hashedAlicePassword = "$6$MsMrE1q.1HrCgTS$Vq2e/uILzYjSN836TobAyN9xh9oi7EmCmucnZID25qgPoibkw8qTCugiAPnn4eCGvn1A.7oEBFJaaGUaJsQQY.";

in
{
  name = "pam-oath-login";

  nodes.machine =
    { ... }:
    {
      security.pam.oath = {
        enable = true;
      };

      users.users.alice = {
        isNormalUser = true;
        name = "alice";
        uid = 1000;
        hashedPassword = hashedAlicePassword;
        extraGroups = [ "wheel" ];
        createHome = true;
        home = "/home/alice";
      };


      systemd.services.setupOathSnakeoilFile = {
        wantedBy = [ "default.target" ];
        before = [ "default.target" ];
        unitConfig = {
          type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          touch /etc/users.oath
          chmod 600 /etc/users.oath
          chown root /etc/users.oath
          echo "HOTP/E/6 alice - ${oathSnakeoilSecret}" > /etc/users.oath
        '';
      };
    };

  testScript = ''
    def switch_to_tty(tty_number):
        machine.fail(f"pgrep -f 'agetty.*tty{tty_number}'")
        machine.send_key(f"alt-f{tty_number}")
        machine.wait_until_succeeds(f"[ $(fgconsole) = {tty_number} ]")
        machine.wait_for_unit(f"getty@tty{tty_number}.service")
        machine.wait_until_succeeds(f"pgrep -f 'agetty.*tty{tty_number}'")


    def enter_user_alice(tty_number):
        machine.wait_until_tty_matches(tty_number, "login: ")
        machine.send_chars("alice\n")
        machine.wait_until_tty_matches(tty_number, "login: alice")
        machine.wait_until_succeeds("pgrep login")
        machine.wait_until_tty_matches(tty_number, "One-time password")


    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
    machine.screenshot("postboot")

    with subtest("Invalid password"):
        switch_to_tty("2")
        enter_user_alice("2")

        machine.send_chars("${oathSnakeOilPassword1}\n")
        machine.wait_until_tty_matches("2", "Password: ")
        machine.send_chars("blorg\n")
        machine.wait_until_tty_matches("2", "Login incorrect")

    with subtest("Invalid oath token"):
        switch_to_tty("3")
        enter_user_alice("3")

        machine.send_chars("000000\n")
        machine.wait_until_tty_matches("3", "Login incorrect")
        machine.wait_until_tty_matches("3", "login:")

    with subtest("Happy path: Both passwords are mandatory to get us in"):
        switch_to_tty("4")
        enter_user_alice("4")

        machine.send_chars("${oathSnakeOilPassword2}\n")
        machine.wait_until_tty_matches("4", "Password: ")
        machine.send_chars("${alicePassword}\n")

        machine.wait_until_succeeds("pgrep -u alice bash")
        machine.send_chars("touch  done4\n")
        machine.wait_for_file("/home/alice/done4")
    '';
})

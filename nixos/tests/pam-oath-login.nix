import ./make-test.nix ({ ... }:

let
  oathSnakeoilSecret = "cdd4083ef8ff1fa9178c6d46bfb1a3";

  # With HOTP mode the password is calculated based on a counter of
  # how many passwords have been made. In this env, we'll always be on
  # the 0th counter, so the password is static.
  #
  # Generated in nix-shell -p oathToolkit
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

  machine =
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

  testScript =
    ''
      $machine->waitForUnit('multi-user.target');
      $machine->waitUntilSucceeds("pgrep -f 'agetty.*tty1'");
      $machine->screenshot("postboot");


      subtest "Invalid password", sub {
        $machine->fail("pgrep -f 'agetty.*tty2'");
        $machine->sendKeys("alt-f2");
        $machine->waitUntilSucceeds("[ \$(fgconsole) = 2 ]");
        $machine->waitForUnit('getty@tty2.service');
        $machine->waitUntilSucceeds("pgrep -f 'agetty.*tty2'");

        $machine->waitUntilTTYMatches(2, "login: ");
        $machine->sendChars("alice\n");
        $machine->waitUntilTTYMatches(2, "login: alice");
        $machine->waitUntilSucceeds("pgrep login");

        $machine->waitUntilTTYMatches(2, "One-time password");
        $machine->sendChars("${oathSnakeOilPassword1}\n");
        $machine->waitUntilTTYMatches(2, "Password: ");
        $machine->sendChars("blorg\n");
        $machine->waitUntilTTYMatches(2, "Login incorrect");
      };

      subtest "Invalid oath token", sub {
        $machine->fail("pgrep -f 'agetty.*tty3'");
        $machine->sendKeys("alt-f3");
        $machine->waitUntilSucceeds("[ \$(fgconsole) = 3 ]");
        $machine->waitForUnit('getty@tty3.service');
        $machine->waitUntilSucceeds("pgrep -f 'agetty.*tty3'");

        $machine->waitUntilTTYMatches(3, "login: ");
        $machine->sendChars("alice\n");
        $machine->waitUntilTTYMatches(3, "login: alice");
        $machine->waitUntilSucceeds("pgrep login");
        $machine->waitUntilTTYMatches(3, "One-time password");
        $machine->sendChars("000000\n");
        $machine->waitUntilTTYMatches(3, "Login incorrect");
        $machine->waitUntilTTYMatches(3, "login:");
      };

      subtest "Happy path (both passwords are mandatory to get us in)", sub {
        $machine->fail("pgrep -f 'agetty.*tty4'");
        $machine->sendKeys("alt-f4");
        $machine->waitUntilSucceeds("[ \$(fgconsole) = 4 ]");
        $machine->waitForUnit('getty@tty4.service');
        $machine->waitUntilSucceeds("pgrep -f 'agetty.*tty4'");

        $machine->waitUntilTTYMatches(4, "login: ");
        $machine->sendChars("alice\n");
        $machine->waitUntilTTYMatches(4, "login: alice");
        $machine->waitUntilSucceeds("pgrep login");
        $machine->waitUntilTTYMatches(4, "One-time password");
        $machine->sendChars("${oathSnakeOilPassword2}\n");
        $machine->waitUntilTTYMatches(4, "Password: ");
        $machine->sendChars("${alicePassword}\n");

        $machine->waitUntilSucceeds("pgrep -u alice bash");
        $machine->sendChars("touch  done4\n");
        $machine->waitForFile("/home/alice/done4");
      };

    '';

})

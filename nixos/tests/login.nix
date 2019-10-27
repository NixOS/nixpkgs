import ./make-test.nix ({ pkgs, latestKernel ? false, ... }:

{
  name = "login";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  machine =
    { pkgs, lib, ... }:
    { boot.kernelPackages = lib.mkIf latestKernel pkgs.linuxPackages_latest;
      sound.enable = true; # needed for the factl test, /dev/snd/* exists without them but udev doesn't care then
    };

  testScript =
    ''
      $machine->waitForUnit('multi-user.target');
      $machine->waitUntilSucceeds("pgrep -f 'agetty.*tty1'");
      $machine->screenshot("postboot");

      subtest "create user", sub {
          $machine->succeed("useradd -m alice");
          $machine->succeed("(echo foobar; echo foobar) | passwd alice");
      };

      # Check whether switching VTs works.
      subtest "virtual console switching", sub {
          $machine->fail("pgrep -f 'agetty.*tty2'");
          $machine->sendKeys("alt-f2");
          $machine->waitUntilSucceeds("[ \$(fgconsole) = 2 ]");
          $machine->waitForUnit('getty@tty2.service');
          $machine->waitUntilSucceeds("pgrep -f 'agetty.*tty2'");
      };

      # Log in as alice on a virtual console.
      subtest "virtual console login", sub {
          $machine->waitUntilTTYMatches(2, "login: ");
          $machine->sendChars("alice\n");
          $machine->waitUntilTTYMatches(2, "login: alice");
          $machine->waitUntilSucceeds("pgrep login");
          $machine->waitUntilTTYMatches(2, "Password: ");
          $machine->sendChars("foobar\n");
          $machine->waitUntilSucceeds("pgrep -u alice bash");
          $machine->sendChars("touch done\n");
          $machine->waitForFile("/home/alice/done");
      };

      # Check whether systemd gives and removes device ownership as
      # needed.
      subtest "device permissions", sub {
          $machine->succeed("getfacl -p /dev/snd/timer | grep -q alice");
          $machine->sendKeys("alt-f1");
          $machine->waitUntilSucceeds("[ \$(fgconsole) = 1 ]");
          $machine->fail("getfacl -p /dev/snd/timer | grep -q alice");
          $machine->succeed("chvt 2");
          $machine->waitUntilSucceeds("getfacl -p /dev/snd/timer | grep -q alice");
      };

      # Log out.
      subtest "virtual console logout", sub {
          $machine->sendChars("exit\n");
          $machine->waitUntilFails("pgrep -u alice bash");
          $machine->screenshot("mingetty");
      };

      # Check whether ctrl-alt-delete works.
      subtest "ctrl-alt-delete", sub {
          $machine->sendKeys("ctrl-alt-delete");
          $machine->waitForShutdown;
      };
    '';

})

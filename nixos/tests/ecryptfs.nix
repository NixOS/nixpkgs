import ./make-test.nix ({ ... }:
{
  name = "ecryptfs";

  machine = { pkgs, ... }: {
    imports = [ ./common/user-account.nix ];
    boot.kernelModules = [ "ecryptfs" ];
    security.pam.enableEcryptfs = true;
    environment.systemPackages = with pkgs; [ keyutils ];
  };

  testScript = ''
    $machine->waitForUnit("default.target");

    # Set alice up with a password and a home
    $machine->succeed("(echo foobar; echo foobar) | passwd alice");
    $machine->succeed("chown -R alice.users ~alice");

    # Migrate alice's home
    my $out = $machine->succeed("echo foobar | ecryptfs-migrate-home -u alice");
    $machine->log("ecryptfs-migrate-home said: $out");

    # Log alice in (ecryptfs passwhrase is wrapped during first login)
    $machine->waitUntilTTYMatches(1, "login: ");
    $machine->sendChars("alice\n");
    $machine->waitUntilTTYMatches(1, "Password: ");
    $machine->sendChars("foobar\n");
    $machine->waitUntilTTYMatches(1, "alice\@machine");
    $machine->sendChars("logout\n");
    $machine->waitUntilTTYMatches(1, "login: ");

    # Why do I need to do this??
    $machine->succeed("su alice -c ecryptfs-umount-private || true");
    $machine->sleep(1);
    $machine->fail("mount | grep ecryptfs"); # check that encrypted home is not mounted

    # Show contents of the user keyring
    my $out = $machine->succeed("su - alice -c 'keyctl list \@u'");
    $machine->log("keyctl unlink said: " . $out);

    # Log alice again
    $machine->waitUntilTTYMatches(1, "login: ");
    $machine->sendChars("alice\n");
    $machine->waitUntilTTYMatches(1, "Password: ");
    $machine->sendChars("foobar\n");
    $machine->waitUntilTTYMatches(1, "alice\@machine");

    # Create some files in encrypted home
    $machine->succeed("su alice -c 'touch ~alice/a'");
    $machine->succeed("su alice -c 'echo c > ~alice/b'");

    # Logout
    $machine->sendChars("logout\n");
    $machine->waitUntilTTYMatches(1, "login: ");

    # Why do I need to do this??
    $machine->succeed("su alice -c ecryptfs-umount-private || true");
    $machine->sleep(1);

    # Check that the filesystem is not accessible
    $machine->fail("mount | grep ecryptfs");
    $machine->succeed("su alice -c 'test \! -f ~alice/a'");
    $machine->succeed("su alice -c 'test \! -f ~alice/b'");

    # Log alice once more
    $machine->waitUntilTTYMatches(1, "login: ");
    $machine->sendChars("alice\n");
    $machine->waitUntilTTYMatches(1, "Password: ");
    $machine->sendChars("foobar\n");
    $machine->waitUntilTTYMatches(1, "alice\@machine");

    # Check that the files are there
    $machine->sleep(1);
    $machine->succeed("su alice -c 'test -f ~alice/a'");
    $machine->succeed("su alice -c 'test -f ~alice/b'");
    $machine->succeed(qq%test "\$(cat ~alice/b)" = "c"%);

    # Catch https://github.com/NixOS/nixpkgs/issues/16766
    $machine->succeed("su alice -c 'ls -lh ~alice/'");

    $machine->sendChars("logout\n");
    $machine->waitUntilTTYMatches(1, "login: ");
  '';
})

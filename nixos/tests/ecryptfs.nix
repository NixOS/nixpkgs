import ./make-test-python.nix ({ ... }:
{
  name = "ecryptfs";

  nodes.machine = { pkgs, ... }: {
    imports = [ ./common/user-account.nix ];
    boot.kernelModules = [ "ecryptfs" ];
    security.pam.enableEcryptfs = true;
    environment.systemPackages = with pkgs; [ keyutils ];
  };

  testScript = ''
    def login_as_alice():
        machine.wait_until_tty_matches("1", "login: ")
        machine.send_chars("alice\n")
        machine.wait_until_tty_matches("1", "Password: ")
        machine.send_chars("foobar\n")
        machine.wait_until_tty_matches("1", "alice\@machine")


    def logout():
        machine.send_chars("logout\n")
        machine.wait_until_tty_matches("1", "login: ")


    machine.wait_for_unit("default.target")

    with subtest("Set alice up with a password and a home"):
        machine.succeed("(echo foobar; echo foobar) | passwd alice")
        machine.succeed("chown -R alice.users ~alice")

    with subtest("Migrate alice's home"):
        out = machine.succeed("echo foobar | ecryptfs-migrate-home -u alice")
        machine.log(f"ecryptfs-migrate-home said: {out}")

    with subtest("Log alice in (ecryptfs passwhrase is wrapped during first login)"):
        login_as_alice()
        machine.send_chars("logout\n")
        machine.wait_until_tty_matches("1", "login: ")

    # Why do I need to do this??
    machine.succeed("su alice -c ecryptfs-umount-private || true")
    machine.sleep(1)

    with subtest("check that encrypted home is not mounted"):
        machine.fail("mount | grep ecryptfs")

    with subtest("Show contents of the user keyring"):
        out = machine.succeed("su - alice -c 'keyctl list \@u'")
        machine.log(f"keyctl unlink said: {out}")

    with subtest("Log alice again"):
        login_as_alice()

    with subtest("Create some files in encrypted home"):
        machine.succeed("su alice -c 'touch ~alice/a'")
        machine.succeed("su alice -c 'echo c > ~alice/b'")

    with subtest("Logout"):
        logout()

    # Why do I need to do this??
    machine.succeed("su alice -c ecryptfs-umount-private || true")
    machine.sleep(1)

    with subtest("Check that the filesystem is not accessible"):
        machine.fail("mount | grep ecryptfs")
        machine.succeed("su alice -c 'test \! -f ~alice/a'")
        machine.succeed("su alice -c 'test \! -f ~alice/b'")

    with subtest("Log alice once more"):
        login_as_alice()

    with subtest("Check that the files are there"):
        machine.sleep(1)
        machine.succeed("su alice -c 'test -f ~alice/a'")
        machine.succeed("su alice -c 'test -f ~alice/b'")
        machine.succeed('test "$(cat ~alice/b)" = "c"')

    with subtest("Catch https://github.com/NixOS/nixpkgs/issues/16766"):
        machine.succeed("su alice -c 'ls -lh ~alice/'")

    logout()
  '';
})

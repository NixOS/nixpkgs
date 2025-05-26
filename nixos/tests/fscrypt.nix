import ./make-test-python.nix (
  { ... }:
  {
    name = "fscrypt";

    nodes.machine =
      { pkgs, ... }:
      {
        imports = [ ./common/user-account.nix ];
        security.pam.enableFscrypt = true;
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

      with subtest("Enable fscrypt on filesystem"):
          machine.succeed("tune2fs -O encrypt /dev/vda")
          machine.succeed("fscrypt setup --quiet --force --time=1ms")

      with subtest("Set up alice with an fscrypt-enabled home directory"):
          machine.succeed("(echo foobar; echo foobar) | passwd alice")
          machine.succeed("chown -R alice.users ~alice")
          machine.succeed("echo foobar | fscrypt encrypt --skip-unlock --source=pam_passphrase --user=alice /home/alice")

      with subtest("Create file as alice"):
        login_as_alice()
        machine.succeed("echo hello > /home/alice/world")
        logout()
        # Wait for logout to be processed
        machine.sleep(1)

      with subtest("File should not be readable without being logged in as alice"):
        machine.fail("cat /home/alice/world")

      with subtest("File should be readable again as alice"):
        login_as_alice()
        machine.succeed("cat /home/alice/world")
        logout()
    '';
  }
)

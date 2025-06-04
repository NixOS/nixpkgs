{ ... }:
{
  name = "fscrypt";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];
      security.pam.enableFscrypt = true;
    };

  testScript = # python
    ''
      def log_in_as_alice():
          machine.wait_until_tty_matches("1", "login: ")
          machine.send_chars("alice\n")
          machine.wait_until_tty_matches("1", "Password: ")
          machine.send_chars("foobar\n")
          machine.wait_until_tty_matches("1", "alice\@machine")


      def log_out():
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
          log_in_as_alice()
          machine.succeed("echo hello > /home/alice/world")
          log_out()
          # Wait for logout to be processed
          machine.sleep(1)

      with subtest("File should not be readable without being logged in as alice"):
          machine.fail("cat /home/alice/world")

      with subtest("File should be readable again as alice"):
          log_in_as_alice()
          assert "Unlocked: Yes" in machine.succeed("fscrypt status /home/alice")
          assert "hello" in machine.succeed("cat /home/alice/world")
          log_out()
    '';
}

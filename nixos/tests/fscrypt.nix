{ ... }:
{
  name = "fscrypt";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];
      security.pam = {
        enableFscrypt = true;
      };
      virtualisation.emptyDiskImages = [ 256 ];
      environment.systemPackages = [
        pkgs.f2fs-tools
      ];
      users.users.bob = {
        home = "/home2/bob";
        createHome = false;
      };
    };

  testScript = # python
    ''
      def log_in(user: str, passwd: str = "foobar") -> None:
          machine.wait_until_tty_matches("1", "login: ")
          machine.send_chars(f"{user}\n")
          machine.wait_until_tty_matches("1", "Password: ")
          machine.send_chars(f"{passwd}\n")
          machine.wait_until_tty_matches("1", f"{user}\@machine")


      def log_out() -> None:
          machine.send_chars("logout\n")
          machine.wait_until_tty_matches("1", "login: ")
          # Wait for logout to be processed
          machine.sleep(1)

      machine.wait_for_unit("default.target")

      with subtest("Setup & enable fscrypt on filesystems"):
          machine.succeed("tune2fs -O encrypt /dev/vda")
          machine.succeed("fscrypt setup --quiet --force --time=1ms")
          machine.succeed("mkfs.f2fs -f -l f2fs-fscrypt -O extra_attr,encrypt /dev/vdb")
          machine.succeed("mount -m -t f2fs /dev/vdb /home2")
          machine.succeed("chmod 755 /home2")
          machine.succeed("fscrypt setup --quiet --force --time=1ms /home2")

      with subtest("Set up alice with an fscrypt-enabled home directory"):
          machine.succeed("(echo foobar; echo foobar) | passwd alice")
          machine.succeed("chown -R alice /home/alice")
          machine.succeed("echo foobar | fscrypt encrypt --skip-unlock --source=pam_passphrase --user=alice /home/alice")

      with subtest("Set up bob with an fscrypt-enabled home directory"):
          machine.succeed("(echo foobar; echo foobar) | passwd bob")
          machine.succeed("mkdir -p /home2/bob")
          machine.succeed("chown -R bob /home2/bob")
          machine.succeed("chmod go-rwx /home2/bob")
          machine.succeed("echo foobar | fscrypt encrypt --skip-unlock --no-recovery --source=pam_passphrase --user=bob /home2/bob")

      with subtest("Create file as alice"):
          log_in("alice")
          machine.succeed("echo hello > /home/alice/world")
          log_out()

      with subtest("Create file as bob"):
          log_in("bob")
          machine.succeed("echo hello > /home2/bob/world")
          log_out()

      with subtest("Files should not be readable without being logged in as alice or bob"):
          machine.fail("cat /home/alice/world")
          machine.fail("cat /home2/bob/world")

      with subtest("File should be readable again as alice"):
          log_in("alice")
          assert "Unlocked: Yes" in machine.succeed("fscrypt status /home/alice")
          assert "hello" in machine.succeed("cat /home/alice/world")
          log_out()

      with subtest("File should be readable again as bob"):
          log_in("bob")
          assert "Unlocked: Yes" in machine.succeed("fscrypt status /home2/bob")
          assert "hello" in machine.succeed("cat /home2/bob/world")
          log_out()
    '';
}

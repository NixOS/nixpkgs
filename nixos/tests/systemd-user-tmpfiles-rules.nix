{ lib, ... }:
{
  name = "systemd-user-tmpfiles-rules";

  meta = with lib.maintainers; {
    maintainers = [ schnusch ];
  };

  nodes.machine =
    { ... }:
    {
      users.users = {
        alice.isNormalUser = true;
        bob.isNormalUser = true;
      };

      systemd.user.tmpfiles = {
        rules = [
          "d %h/user_tmpfiles_created"
        ];
        users.alice.rules = [
          "d %h/only_alice"
        ];
        users.bob.rules = [
          "D %h/cleaned_up - - - 0"
        ];
      };

      # run every 10 seconds
      systemd.user.timers.systemd-tmpfiles-clean.timerConfig = {
        OnStartupSec = "10s";
        OnUnitActiveSec = "10s";
      };
    };

  testScript =
    { ... }:
    ''
      machine.succeed("loginctl enable-linger alice bob")

      machine.wait_until_succeeds("systemctl --user --machine=alice@ is-active systemd-tmpfiles-setup.service")
      machine.succeed("[ -d ~alice/user_tmpfiles_created ]")
      machine.succeed("[ -d ~alice/only_alice ]")

      machine.wait_until_succeeds("systemctl --user --machine=bob@ is-active systemd-tmpfiles-setup.service")
      machine.succeed("[ -d ~bob/user_tmpfiles_created ]")
      machine.succeed("[ ! -e ~bob/only_alice ]")

      machine.succeed("systemctl --user --machine=bob@ is-active systemd-tmpfiles-clean.timer")
      machine.succeed("runuser -u bob -- touch ~bob/cleaned_up/file")
      machine.wait_until_fails("[ -e ~bob/cleaned_up/file ]")
    '';
}

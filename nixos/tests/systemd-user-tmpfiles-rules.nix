import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "systemd-user-tmpfiles-rules";

    meta = with lib.maintainers; {
      maintainers = [ schnusch ];
    };

    nodes = {
      machine =
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
          systemd.user.timers.systemd-tmpfiles-clean = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnStartupSec = "10s";
              OnUnitActiveSec = "10s";
            };
          };
        };

      default =
        { ... }:
        {
          users.users = {
            alice.isNormalUser = true;
          };

          systemd.user.tmpfiles = {
            rules = [
              "d %h/user_tmpfiles_created"
            ];
          };
        };
    };

    testScript =
      { ... }:
      ''
        # Test if `systemd-tmpfiles-clean.timer` is not enabled if we do not change
        # anything below `systemd.user.timers.systemd-tmpfiles-clean`.
        default.succeed("loginctl enable-linger alice")
        default.wait_until_succeeds("systemctl --user --machine=alice@ is-active systemd-tmpfiles-setup.service")
        default.fail("systemctl --user --machine=alice@ is-active systemd-tmpfiles-clean.timer")

        # test user-tmpfiles.d
        machine.succeed("loginctl enable-linger alice bob")

        machine.wait_until_succeeds("systemctl --user --machine=alice@ is-active systemd-tmpfiles-setup.service")
        machine.succeed("[ -d ~alice/user_tmpfiles_created ]")
        machine.succeed("[ -d ~alice/only_alice ]")

        machine.wait_until_succeeds("systemctl --user --machine=bob@ is-active systemd-tmpfiles-setup.service")
        machine.succeed("[ -d ~bob/user_tmpfiles_created ]")
        machine.succeed("[ ! -e ~bob/only_alice ]")

        machine.succeed("systemctl --user --machine=bob@ is-active systemd-tmpfiles-clean.timer")
        machine.succeed(
            # we cannot combine `--machine=bob@` and `cat`
            # runuser -l does not set $XDG_RUNTIME_DIR
            'runuser -u bob -- env XDG_RUNTIME_DIR="/run/user/$(id -u bob)" systemctl --user cat systemd-tmpfiles-clean.timer >&2'
        )
        machine.succeed("runuser -u bob -- touch ~bob/cleaned_up/file")
        machine.wait_until_fails("[ -e ~bob/cleaned_up/file ]")
      '';
  }
)

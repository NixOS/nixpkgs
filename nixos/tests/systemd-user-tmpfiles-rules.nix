import ./make-test-python.nix ({ lib, ... }: {
  name = "systemd-user-tmpfiles-rules";

  meta = with lib.maintainers; {
    maintainers = [ schnusch ];
  };

  nodes.machine = { ... }: {
    users.users = {
      alice.isNormalUser = true;
      bob.isNormalUser = true;
    };

    systemd.user.tmpfiles = {
      rules = [
        "d %h/user_tmpfiles_created"
      ];
      settings = {
        "10-test" = {
          "%h/user_tmpfiles_settings".d = {};
        };
      };
      users.alice.rules = [
        "d %h/only_alice"
      ];
      users.alice.settings = {
        "10-test" = {
          "%h/only_alice_settings".d = {};
        };
      };
    };
  };

  testScript = { ... }: ''
    machine.succeed("loginctl enable-linger alice bob")

    machine.wait_until_succeeds("systemctl --user --machine=alice@ is-active systemd-tmpfiles-setup.service")
    machine.succeed("[ -d ~alice/user_tmpfiles_created ]")
    machine.succeed("[ -d ~alice/user_tmpfiles_settings ]")
    machine.succeed("[ -d ~alice/only_alice ]")
    machine.succeed("[ -d ~alice/only_alice_settings ]")

    machine.wait_until_succeeds("systemctl --user --machine=bob@ is-active systemd-tmpfiles-setup.service")
    machine.succeed("[ -d ~bob/user_tmpfiles_created ]")
    machine.succeed("[ -d ~bob/user_tmpfiles_settings ]")
    machine.succeed("[ ! -e ~bob/only_alice ]")
    machine.succeed("[ ! -e ~bob/only_alice_settings ]")
  '';
})

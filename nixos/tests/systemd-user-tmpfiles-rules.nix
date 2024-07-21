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
      users.alice.rules = [
        "d %h/only_alice"
      ];
    };
  };

  testScript = { ... }: ''
    machine.succeed("loginctl enable-linger alice bob")

    machine.wait_until_succeeds("systemctl --user --machine=alice@ is-active systemd-tmpfiles-setup.service")
    machine.succeed("[ -d ~alice/user_tmpfiles_created ]")
    machine.succeed("[ -d ~alice/only_alice ]")

    machine.wait_until_succeeds("systemctl --user --machine=bob@ is-active systemd-tmpfiles-setup.service")
    machine.succeed("[ -d ~bob/user_tmpfiles_created ]")
    machine.succeed("[ ! -e ~bob/only_alice ]")
  '';
})

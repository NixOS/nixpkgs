import ./make-test-python.nix ({ lib, ... }: {
  name = "systemd-user-tmpfiles-rules";

  meta = with lib.maintainers; {
    maintainers = [ schnusch ];
  };

  nodes.machine = { ... }: {
    users.users = {
      alice = {
        isNormalUser = true;
        linger = true;
      };
      bob = {
        isNormalUser = true;
        linger = true;
      };
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
    machine.wait_for_unit("user@$(id -u alice)")
    machine.wait_for_unit("systemd-tmpfiles-setup.service", "alice")
    machine.succeed("[ -d ~alice/user_tmpfiles_created ]")
    machine.succeed("[ -d ~alice/only_alice ]")

    machine.wait_for_unit("user@$(id -u alice)")
    machine.wait_for_unit("systemd-tmpfiles-setup.service", "bob")
    machine.succeed("[ -d ~bob/user_tmpfiles_created ]")
    machine.succeed("[ ! -e ~bob/only_alice ]")
  '';
})

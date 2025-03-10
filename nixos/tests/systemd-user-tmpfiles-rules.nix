import ./make-test-python.nix (
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

    testScript =
      { nodes, ... }:
      let
        inherit (nodes.machine.users.users) alice bob;
      in
      ''
        machine.wait_for_unit("user@$(id -u ${alice.name})")
        machine.wait_for_unit("systemd-tmpfiles-setup.service", "${alice.name}")
        machine.succeed("[ -d ~${alice.name}/user_tmpfiles_created ]")
        machine.succeed("[ -d ~${alice.name}/only_alice ]")

        machine.wait_for_unit("user@$(id -u ${bob.name})")
        machine.wait_for_unit("systemd-tmpfiles-setup.service", "${bob.name}")
        machine.succeed("[ -d ~${bob.name}/user_tmpfiles_created ]")
        machine.succeed("[ ! -e ~${bob.name}/only_alice ]")
      '';
  }
)

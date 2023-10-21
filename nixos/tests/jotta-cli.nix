import ./make-test-python.nix (
  { pkgs, ... }:
  {

    name = "jotta-cli";
    meta.maintainers = with pkgs.lib.maintainers; [ evenbrenden ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.jotta-cli.enable = true;
        users.users.alice.linger = true;
        imports = [ ./common/user-account.nix ];
      };

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
        runtimeUID = "$(id -u ${user.name})";
      in
      ''
        machine.start()

        machine.wait_for_unit("user@${runtimeUID}.service")

        machine.wait_for_unit("jottad.service", "${user.name}")
        machine.wait_for_open_unix_socket("/run/user/${runtimeUID}/jottad/jottad.socket")

        # "jotta-cli version" should fail if jotta-cli cannot connect to jottad
        machine.succeed('XDG_RUNTIME_DIR=/run/user/${runtimeUID} su ${user.name} -c "jotta-cli version"')
      '';
  }
)

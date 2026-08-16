{ pkgs, ... }:
{

  name = "jotta-cli";
  meta.maintainers = with pkgs.lib.maintainers; [ evenbrenden ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.jotta-cli.enable = true;
      imports = [ ./common/user-account.nix ];
    };

  testScript =
    { nodes, ... }:
    let
      uid = toString nodes.machine.users.users.alice.uid;
    in
    ''
      machine.start()

      machine.succeed("loginctl enable-linger alice")
      machine.wait_for_unit("user@${uid}.service")

      machine.wait_for_unit("jottad.service", "alice")
      machine.wait_for_open_unix_socket("/run/user/${uid}/jottad/jottad.socket")

      # "jotta-cli version" should fail if jotta-cli cannot connect to jottad
      machine.succeed('XDG_RUNTIME_DIR=/run/user/${uid} su alice -c "jotta-cli version"')
    '';
}

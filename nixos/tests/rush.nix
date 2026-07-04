{ pkgs, ... }:
let
  inherit (import ./ssh-keys.nix pkgs) snakeOilEd25519PrivateKey snakeOilEd25519PublicKey;
  username = "nix-remote-builder";
in
{
  name = "rush";
  meta = { inherit (pkgs.rush.meta) maintainers platforms; };

  nodes = {
    client =
      { ... }:
      {
        nix.settings.extra-experimental-features = [ "nix-command" ];
      };

    server =
      { config, ... }:
      {
        nix.settings.trusted-users = [ "${username}" ];

        programs.rush = {
          enable = true;
          global = "debug 1";

          rules = {
            daemon = ''
              match $# == 2
              match $0 == "nix-daemon"
              match $1 == "--stdio"
              match $user == "${username}"
              chdir "${config.nix.package}/bin"
            '';

            whoami = ''
              match $# == 1
              match $0 == "whoami"
              match $user == "${username}"
              chdir "${dirOf config.environment.usrbinenv}"
            '';
          };
        };

        services.openssh = {
          enable = true;

          extraConfig = ''
            Match User ${username}
              AllowAgentForwarding no
              AllowTcpForwarding no
              PermitTTY no
              PermitTunnel no
              X11Forwarding no
            Match All
          '';
        };

        users = {
          groups."${username}" = { };

          users."${username}" = {
            inherit (config.programs.rush) shell;
            group = "${username}";
            isSystemUser = true;
            openssh.authorizedKeys.keys = [ snakeOilEd25519PublicKey ];
          };
        };
      };
  };

  testScript = ''
    start_all()

    client.succeed("mkdir -m 700 /root/.ssh")
    client.succeed("cat '${snakeOilEd25519PrivateKey}' | tee /root/.ssh/id_ed25519")
    client.succeed("chmod 600 /root/.ssh/id_ed25519")

    server.wait_for_unit("sshd")

    client.succeed("ssh-keyscan -H server | tee -a /root/.ssh/known_hosts")

    client.succeed("ssh ${username}@server -- whoami")
    client.succeed("nix store info --store 'ssh-ng://${username}@server'")

    client.fail("ssh ${username}@server -- date")
    client.fail("nix store info --store 'ssh://${username}@server'")
  '';
}

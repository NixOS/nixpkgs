{
  pkgs,
  lib,
  config,
  ...
}:
# This tests that systemd-ssh-proxy and systemd-ssh-generator work correctly with:
# - a local unix socket on the same system
# - a unix socket inside a container
let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilEd25519PrivateKey
    snakeOilEd25519PublicKey
    ;
in
{
  name = "systemd-ssh-proxy";
  meta.maintainers = with pkgs.lib.maintainers; [ marie ];

  nodes = {
    virthost = {
      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "prohibit-password";
      };
      users.users = {
        root.openssh.authorizedKeys.keys = [ snakeOilEd25519PublicKey ];
        nixos = {
          isNormalUser = true;
        };
      };
      containers.guest = {
        autoStart = true;
        config = {
          users.users.root.openssh.authorizedKeys.keys = [ snakeOilEd25519PublicKey ];
          services.openssh = {
            enable = true;
            settings.PermitRootLogin = "prohibit-password";
          };
          system.stateVersion = lib.trivial.release;
        };
      };
    };
  };

  testScript = ''
    virthost.succeed("mkdir -p ~/.ssh")
    virthost.succeed("cp '${snakeOilEd25519PrivateKey}' ~/.ssh/id_ed25519")
    virthost.succeed("chmod 600 ~/.ssh/id_ed25519")

    with subtest("ssh into a container with AF_UNIX"):
      virthost.wait_for_unit("container@guest.service")
      virthost.wait_until_succeeds("ssh -i ~/.ssh/id_ed25519 unix/run/systemd/nspawn/unix-export/guest/ssh echo meow | grep meow")

    with subtest("elevate permissions using local ssh socket"):
      virthost.wait_for_unit("sshd-unix-local.socket")
      virthost.succeed("sudo --user=nixos mkdir -p /home/nixos/.ssh")
      virthost.succeed("cp ~/.ssh/id_ed25519 /home/nixos/.ssh/id_ed25519")
      virthost.succeed("chmod 600 /home/nixos/.ssh/id_ed25519")
      virthost.succeed("chown nixos /home/nixos/.ssh/id_ed25519")
      virthost.succeed("sudo --user=nixos ssh -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -i /home/nixos/.ssh/id_ed25519 root@.host whoami | grep root")
  '';
}

{ config, lib, pkgs, ... }:

let
  serveOnly = pkgs.writeScript "nix-store-serve" ''
    #!${pkgs.stdenv.shell}
    if [ "$SSH_ORIGINAL_COMMAND" != "nix-store --serve" ]; then
      echo 'Error: You are only allowed to run `nix-store --serve'\'''!' >&2
      exit 1
    fi
    exec /run/current-system/sw/bin/nix-store --serve
  '';

  inherit (lib) mkIf mkOption types;
in {
  options = {
    nix.sshServe = {
      enable = mkOption {
        description = "Whether to enable serving the nix store over ssh.";
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf config.nix.sshServe.enable {
    users.extraUsers.nix-ssh = {
      description = "User for running nix-store --serve.";
      uid = config.ids.uids.nix-ssh;
      shell = pkgs.stdenv.shell;
    };

    services.openssh.enable = true;

    services.openssh.extraConfig = ''
      Match User nix-ssh
        AllowAgentForwarding no
        AllowTcpForwarding no
        PermitTTY no
        PermitTunnel no
        X11Forwarding no
        ForceCommand ${serveOnly}
      Match All
    '';
  };
}

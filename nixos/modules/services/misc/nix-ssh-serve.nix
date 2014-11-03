{ config, lib, pkgs, ... }:

with lib;

{
  options = {

    nix.sshServe = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable serving the Nix store as a binary cache via SSH.";
      };

      keys = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "ssh-dss AAAAB3NzaC1k... alice@example.org" ];
        description = "A list of SSH public keys allowed to access the binary cache via SSH.";
      };

    };

  };

  config = mkIf config.nix.sshServe.enable {

    users.extraUsers.nix-ssh = {
      description = "Nix SSH substituter user";
      uid = config.ids.uids.nix-ssh;
      useDefaultShell = true;
    };

    services.openssh.enable = true;

    services.openssh.extraConfig = ''
      Match User nix-ssh
        AllowAgentForwarding no
        AllowTcpForwarding no
        PermitTTY no
        PermitTunnel no
        X11Forwarding no
        ForceCommand ${config.nix.package}/bin/nix-store --serve
      Match All
    '';

    users.extraUsers.nix-ssh.openssh.authorizedKeys.keys = config.nix.sshServe.keys;

  };
}

{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    nix.sshServe = {
      enable = mkOption {
        description = "Whether to enable serving the Nix store as a binary cache via SSH.";
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf config.nix.sshServe.enable {
    users.extraUsers.nix-ssh = {
      description = "Nix SSH substituter user";
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
        ForceCommand ${config.nix.package}/bin/nix-store --serve
      Match All
    '';
  };
}

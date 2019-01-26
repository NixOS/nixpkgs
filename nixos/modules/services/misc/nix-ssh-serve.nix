{ config, lib, ... }:

with lib;
let cfg = config.nix.sshServe;
    command =
      if cfg.protocol == "ssh"
        then "nix-store --serve"
      else "nix-daemon --stdio";
in {
  options = {

    nix.sshServe = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable serving the Nix store as a remote store via SSH.";
      };

      keys = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "ssh-dss AAAAB3NzaC1k... alice@example.org" ];
        description = "A list of SSH public keys allowed to access the binary cache via SSH.";
      };

      protocol = mkOption {
        type = types.enum [ "ssh" "ssh-ng" ];
        default = "ssh";
        description = "The specific Nix-over-SSH protocol to use.";
      };

    };

  };

  config = mkIf cfg.enable {

    users.users.nix-ssh = {
      description = "Nix SSH store user";
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
        ForceCommand ${config.nix.package.out}/bin/${command}
      Match All
    '';

    users.users.nix-ssh.openssh.authorizedKeys.keys = cfg.keys;

  };
}

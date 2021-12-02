{ config, lib, ... }:

with lib;
let cfg = config.nix.sshServe;
    command =
      if cfg.protocol == "ssh"
        then "nix-store --serve ${lib.optionalString cfg.write "--write"}"
      else "nix-daemon --stdio";
in {
  options = {

    nix.sshServe = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable serving the Nix store as a remote store via SSH.";
      };

      write = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable writing to the Nix store as a remote store via SSH. Note: the sshServe user is named nix-ssh and is not a trusted-user. nix-ssh should be added to the nix.trustedUsers option in most use cases, such as allowing remote building of derivations.";
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
      isSystemUser = true;
      group = "nix-ssh";
      useDefaultShell = true;
    };
    users.groups.nix-ssh = {};

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

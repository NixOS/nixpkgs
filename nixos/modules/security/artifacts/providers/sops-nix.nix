{ config, lib, pkgs, ... }:

let
  cfg = config.security.artifacts;
in {
  config = lib.mkIf (cfg.enable && cfg.provider == "sops-nix") {
    # Translate the generic secret abstraction to sops.secrets
    sops.secrets = lib.mapAttrs (name: secret: {
      owner = secret.owner;
      group = secret.group;
      mode = secret.mode;
      path = if secret.path != null then secret.path else "/run/secrets/${name}";
    }) cfg.secrets;

    # Ensure systemd synchronization target knows when sops-nix is finished
    systemd.targets.nixos-artifacts-secrets.after = [ "sops-nix.service" ];
    systemd.targets.nixos-artifacts-secrets.requires = [ "sops-nix.service" ];
  };
}

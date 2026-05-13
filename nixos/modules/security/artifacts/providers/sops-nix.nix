{ config, lib, pkgs, ... }:

let
  cfg = config.security.artifacts;
in {
  config = lib.mkIf (cfg.enable && cfg.provider == "sops-nix") {
    # Translate the generic nixos-artifacts secret declarations into the
    # sops-nix module's native `sops.secrets.<name>` options.
    #
    # Each artifact secret maps 1:1 to a sops-nix secret.  The `source`
    # attribute provides the path to the encrypted SOPS file.

    sops.secrets = lib.mapAttrs (name: secret: {
      sopsFile = secret.source;
      owner = secret.owner;
      group = secret.group;
      mode = secret.mode;
      path = secret.path;
    }) cfg.secrets;

    # Wire the synchronization target to sops-nix's activation service.
    systemd.targets.nixos-artifacts-secrets = {
      after = [ "sops-nix.service" ];
      requires = [ "sops-nix.service" ];
    };
  };
}

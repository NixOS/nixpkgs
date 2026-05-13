{ config, lib, pkgs, ... }:

let
  cfg = config.security.artifacts;
in {
  config = lib.mkIf (cfg.enable && cfg.provider == "agenix") {
    # Translate the generic nixos-artifacts secret declarations into the
    # agenix module's native `age.secrets.<name>` options.
    #
    # Each artifact secret maps 1:1 to an agenix secret.  The `source`
    # attribute must point to the `.age` encrypted file.

    age.secrets = lib.mapAttrs (name: secret: {
      file = secret.source;
      owner = secret.owner;
      group = secret.group;
      mode = secret.mode;
      path = secret.path;
    }) cfg.secrets;

    # Wire the synchronization target to agenix's activation service.
    systemd.targets.nixos-artifacts-secrets = {
      after = [ "agenix.service" ];
      requires = [ "agenix.service" ];
    };
  };
}

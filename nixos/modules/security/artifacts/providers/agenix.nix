{ config, lib, pkgs, ... }:

let
  cfg = config.security.artifacts;
in {
  config = lib.mkIf (cfg.enable && cfg.provider == "agenix") {
    # Translate the generic secret abstraction to age.secrets
    age.secrets = lib.mapAttrs (name: secret: {
      # agenix requires a source file path for the .age file.
      # By convention in this translation layer, we assume it's located at
      # a path similar to the secret name in a predetermined directory,
      # but agenix configuration generally expects an explicit `file`.
      # For a true generic translation, we assume the user provides the age file path
      # either globally or we default to a standard lookup.
      # Here we map the exact matching agenix secret name if provided in agenix configuration.
      file = lib.mkDefault "/etc/nixos/secrets/${name}.age";
      owner = secret.owner;
      group = secret.group;
      mode = secret.mode;
      path = if secret.path != null then builtins.toString secret.path else "/run/secrets/${name}";
    }) cfg.secrets;

    # Link the target to agenix's activation
    systemd.targets.nixos-artifacts-secrets.after = [ "agenix.service" ];
    systemd.targets.nixos-artifacts-secrets.requires = [ "agenix.service" ];
  };
}

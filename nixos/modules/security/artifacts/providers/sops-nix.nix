{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.security.artifacts;
in
{
  config = lib.mkIf (cfg.enable && cfg.provider == "sops-nix") (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = options ? sops;
            message = "security.artifacts.provider is set to 'sops-nix', but the sops-nix module is not imported.";
          }
        ];

        # Wire the synchronization target to sops-nix's activation service.
        systemd.targets.nixos-artifacts-secrets = {
          after = [ "sops-nix.service" ];
          requires = [ "sops-nix.service" ];
        };
      }
      (lib.optionalAttrs (options ? sops) {
        # Translate the generic nixos-artifacts secret declarations into the
        # sops-nix module's native `sops.secrets.<name>` options.
        sops.secrets = lib.mapAttrs (name: secret: {
          sopsFile = secret.source;
          owner = secret.owner;
          group = secret.group;
          mode = secret.mode;
          path = secret.path;
        }) cfg.secrets;
      })
    ]
  );
}

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
  config = lib.mkIf (cfg.enable && cfg.provider == "agenix") (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = options ? age;
            message = "security.artifacts.provider is set to 'agenix', but the agenix module is not imported.";
          }
        ];

        # Wire the synchronization target to agenix's activation service.
        systemd.targets.nixos-artifacts-secrets = {
          after = [ "agenix.service" ];
          requires = [ "agenix.service" ];
        };
      }
      (lib.optionalAttrs (options ? age) {
        # Translate the generic nixos-artifacts secret declarations into the
        # agenix module's native `age.secrets.<name>` options.
        age.secrets = lib.mapAttrs (name: secret: {
          file = secret.source;
          owner = secret.owner;
          group = secret.group;
          mode = secret.mode;
          path = secret.path;
        }) cfg.secrets;
      })
    ]
  );
}

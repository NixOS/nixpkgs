{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.kopia;
in
{
  options.services.kopia.backups = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.policies = {
          entries = lib.mkOption {
            type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
            default = { };
            description = ''
              Policy entries for this backup, keyed by kopia target specifier.

              Targets use kopia's string format:
              - `"(global)"`: the repository-wide global policy
              - `"user@host:/path"`: policy for a specific snapshot path
              - `"*@host"`, `"user@*"`: wildcard host or user patterns

              Values are kopia policy objects in JSON format (camelCase field
              names), passed verbatim to `kopia policy import`. Use
              `kopia policy export` to inspect the format.

              The resulting JSON file is written to the world-readable Nix
              store; do not put secrets in policy `actions`.
            '';
            example = lib.literalExpression ''
              {
                "(global)" = {
                  retention.keepDaily = 30;
                  compression.compressorName = "zstd";
                };
              }
            '';
          };

          declarative = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Whether to delete all policies not defined by this module.
              Passes `--delete-other-policies` to `kopia policy import`.
            '';
          };
        };
      }
    );
  };

  config = lib.mkIf (cfg.backups != { }) {
    systemd.services = lib.mapAttrs' (
      name: backup:
      let
        kopiaExe = lib.getExe cfg.package;
        policyFile = pkgs.writeText "kopia-policy-${name}.json" (
          builtins.toJSON backup.policies.entries
        );
      in
      lib.nameValuePair "kopia-policy-${name}" {
        description = "Kopia policy import for ${name}";
        requires = [ "kopia-repository-${name}.service" ];
        after = [ "kopia-repository-${name}.service" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          KOPIA_CONFIG_PATH = "/var/lib/kopia/${name}/repository.config";
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = backup.user;
          StateDirectory = "kopia/${name}";
          PrivateTmp = true;
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ReadWritePaths = [
            "/var/lib/kopia/${name}"
          ]
          ++ lib.optional (backup.repository ? filesystem) backup.repository.filesystem.path;
        };
        script = ''
          set -euo pipefail
          export KOPIA_PASSWORD="$(cat ${lib.escapeShellArg backup.passwordFile})"
          ${kopiaExe} policy import \
            ${lib.optionalString backup.policies.declarative "--delete-other-policies"} \
            --from-file=${policyFile}
        '';
      }
    ) (lib.filterAttrs (_: backup: backup.policies.entries != { }) cfg.backups);
  };
}

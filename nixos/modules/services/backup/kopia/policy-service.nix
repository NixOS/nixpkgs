{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.kopia;
  helpers = import ./helpers.nix { inherit lib config; };
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

  config =
    let
      effectivePolicies =
        backup:
        let
          snapshotPolicyEntries = lib.foldl' lib.mergeAttrs { } (
            lib.mapAttrsToList (
              _: snapshot:
              lib.optionalAttrs (snapshot.policy != { }) {
                ${helpers.snapshotTarget backup snapshot} = snapshot.policy;
              }
            ) backup.snapshots
          );
        in
        lib.recursiveUpdate snapshotPolicyEntries backup.policies.entries;

      # Snapshots whose `policy` field would collide in `policies.entries`
      # because they resolve to the same `user@host:/path` source identifier.
      # `lib.mergeAttrs` is shallow right-biased, so a collision would silently
      # drop the earlier snapshot's policy; assert instead.
      duplicatePolicyTargets =
        backup:
        let
          policied = lib.filterAttrs (_: s: s.policy != { }) backup.snapshots;
          entries = lib.mapAttrsToList (snapName: snapshot: {
            inherit snapName;
            target = helpers.snapshotTarget backup snapshot;
          }) policied;
        in
        lib.filterAttrs (_: es: lib.length es > 1) (lib.groupBy (e: e.target) entries);
    in
    lib.mkIf (cfg.backups != { }) {
      assertions = lib.concatLists (
        lib.mapAttrsToList (
          backupName: backup:
          lib.mapAttrsToList (target: entries: {
            assertion = false;
            message =
              "services.kopia.backups.${backupName}: snapshots "
              + lib.concatMapStringsSep ", " (e: ''"${e.snapName}"'') entries
              + " all resolve to the kopia source identifier `${target}`; "
              + "their `policy` attributes would silently overwrite each "
              + "other in `policies.entries`. Distinguish them via "
              + "`source.{user,host,path}` overrides.";
          }) (duplicatePolicyTargets backup)
        ) cfg.backups
      );

      systemd.services = lib.mapAttrs' (
        name: backup:
        let
          kopiaExe = lib.getExe cfg.package;
          policies = effectivePolicies backup;
          policyFile = pkgs.writeText "kopia-policy-${name}.json" (builtins.toJSON policies);
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
      ) (lib.filterAttrs (_: backup: effectivePolicies backup != { }) cfg.backups);
    };
}

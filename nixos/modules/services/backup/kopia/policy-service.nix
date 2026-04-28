{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.kopia;
  helpers = import ./helpers.nix { inherit lib; };
in
{
  options.services.kopia.backups = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.policy = {
          retention = {
            keepLatest = lib.mkOption {
              type = with lib.types; nullOr ints.positive;
              default = null;
              description = "Number of latest snapshots to keep.";
            };
            keepHourly = lib.mkOption {
              type = with lib.types; nullOr ints.positive;
              default = null;
              description = "Number of hourly snapshots to keep.";
            };
            keepDaily = lib.mkOption {
              type = with lib.types; nullOr ints.positive;
              default = null;
              description = "Number of daily snapshots to keep.";
            };
            keepWeekly = lib.mkOption {
              type = with lib.types; nullOr ints.positive;
              default = null;
              description = "Number of weekly snapshots to keep.";
            };
            keepMonthly = lib.mkOption {
              type = with lib.types; nullOr ints.positive;
              default = null;
              description = "Number of monthly snapshots to keep.";
            };
            keepAnnual = lib.mkOption {
              type = with lib.types; nullOr ints.positive;
              default = null;
              description = "Number of annual snapshots to keep.";
            };
          };

          compression = lib.mkOption {
            type =
              with lib.types;
              nullOr (enum [
                "none"
                "deflate-best-compression"
                "deflate-best-speed"
                "deflate-default"
                "gzip"
                "gzip-best-compression"
                "gzip-best-speed"
                "pgzip"
                "pgzip-best-compression"
                "pgzip-best-speed"
                "s2-better"
                "s2-default"
                "s2-parallel-4"
                "s2-parallel-8"
                "zstd"
                "zstd-better-compression"
                "zstd-fastest"
              ]);
            default = null;
            description = ''
              Compression algorithm for snapshots.
              Run `kopia policy set --help` for the list of supported algorithms.
            '';
            example = "zstd";
          };

          files = {
            ignore = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "List of glob patterns to ignore.";
              example = [
                "*.tmp"
                "*.log"
              ];
            };
            ignoreDotFiles = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "List of dot-ignore files to source ignore patterns from.";
              example = [
                ".gitignore"
                ".kopiaignore"
              ];
            };
            ignoreCacheDirs = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = "Whether to ignore cache directories.";
            };
            maxFileSize = lib.mkOption {
              type = with lib.types; nullOr ints.positive;
              default = null;
              description = "Maximum file size (in bytes) to include in backup.";
            };
            oneFileSystem = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = "Whether to stay within one filesystem when finding files.";
            };
            noParentIgnore = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = "Whether to not inherit ignore patterns from parent directories.";
            };
          };

          errorHandling = {
            ignoreFileErrors = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = "Whether to ignore errors reading files.";
            };
            ignoreDirectoryErrors = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = "Whether to ignore errors reading directories.";
            };
            ignoreUnknownTypes = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = "Whether to ignore unknown file types.";
            };
          };

          splitter = {
            algorithm = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = "Splitter algorithm to use.";
            };
          };
        };
      }

    );
  };

  config =
    let
      # Build policy CLI args from non-null options using a data-driven approach
      mkPolicyArgs =
        backup:
        let
          p = backup.policy;

          # Declarative mapping: CLI flag → option value
          flagMap = [
            {
              flag = "keep-latest";
              value = p.retention.keepLatest;
            }
            {
              flag = "keep-hourly";
              value = p.retention.keepHourly;
            }
            {
              flag = "keep-daily";
              value = p.retention.keepDaily;
            }
            {
              flag = "keep-weekly";
              value = p.retention.keepWeekly;
            }
            {
              flag = "keep-monthly";
              value = p.retention.keepMonthly;
            }
            {
              flag = "keep-annual";
              value = p.retention.keepAnnual;
            }
            {
              flag = "compression";
              value = p.compression;
            }
            {
              flag = "ignore-cache-dirs";
              value = p.files.ignoreCacheDirs;
            }
            {
              flag = "max-file-size";
              value = p.files.maxFileSize;
            }
            {
              flag = "one-file-system";
              value = p.files.oneFileSystem;
            }
            {
              flag = "no-parent-ignore";
              value = p.files.noParentIgnore;
            }
            {
              flag = "ignore-file-errors";
              value = p.errorHandling.ignoreFileErrors;
            }
            {
              flag = "ignore-dir-errors";
              value = p.errorHandling.ignoreDirectoryErrors;
            }
            {
              flag = "ignore-unknown-types";
              value = p.errorHandling.ignoreUnknownTypes;
            }
            {
              flag = "splitter";
              value = p.splitter.algorithm;
            }
          ];

          # List-type args (expand one value → multiple --flag= args)
          listFlagMap = [
            {
              flag = "add-ignore";
              values = p.files.ignore;
            }
            {
              flag = "add-dot-ignore";
              values = p.files.ignoreDotFiles;
            }
          ];

          # Single dispatcher: null → skip, bool → boolToString, else → toString
          mkArg =
            { flag, value }:
            lib.optional (value != null)
              "--${flag}=${if lib.isBool value then lib.boolToString value else toString value}";

          mkListArgs = { flag, values }: map (v: "--${flag}=${lib.escapeShellArg v}") values;
        in
        lib.concatLists (map mkArg flagMap) ++ lib.concatLists (map mkListArgs listFlagMap);
    in
    lib.mkIf (cfg.backups != { }) {
      systemd.services = lib.mapAttrs' (
        name: backup:
        let
          policyArgs = lib.concatStringsSep " " (mkPolicyArgs backup);
          policyScript = ''
            set -euo pipefail
            export KOPIA_PASSWORD="$(cat ${lib.escapeShellArg backup.passwordFile})"

            ${lib.concatMapStringsSep "\n" (path: ''
              ${lib.getExe cfg.package} policy set ${lib.escapeShellArg path} ${policyArgs}
            '') backup.paths}
          '';
        in
        lib.nameValuePair "kopia-policy-${name}" {
          description = "Kopia policy for ${name}";
          requires = [ "kopia-repository-${name}.service" ];
          after = [ "kopia-repository-${name}.service" ];
          before = lib.mkIf (backup.paths != [ ]) [ "kopia-snapshot-${name}.service" ];
          wantedBy = lib.mkIf (backup.paths != [ ]) [ "kopia-snapshot-${name}.service" ];
          environment = {
            KOPIA_CONFIG_PATH = "/var/lib/kopia/${name}/repository.config";
          };
          restartIfChanged = false;
          serviceConfig = {
            Type = "oneshot";
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
          script = policyScript;
        }
      ) (lib.filterAttrs (_: b: helpers.hasPolicySet b) cfg.backups);
    };
}

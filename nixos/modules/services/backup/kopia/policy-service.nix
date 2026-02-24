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
            keep-latest = lib.mkOption {
              type = with lib.types; nullOr ints.unsigned;
              default = null;
              description = "Number of latest snapshots to keep.";
            };
            keep-hourly = lib.mkOption {
              type = with lib.types; nullOr ints.unsigned;
              default = null;
              description = "Number of hourly snapshots to keep.";
            };
            keep-daily = lib.mkOption {
              type = with lib.types; nullOr ints.unsigned;
              default = null;
              description = "Number of daily snapshots to keep.";
            };
            keep-weekly = lib.mkOption {
              type = with lib.types; nullOr ints.unsigned;
              default = null;
              description = "Number of weekly snapshots to keep.";
            };
            keep-monthly = lib.mkOption {
              type = with lib.types; nullOr ints.unsigned;
              default = null;
              description = "Number of monthly snapshots to keep.";
            };
            keep-annual = lib.mkOption {
              type = with lib.types; nullOr ints.unsigned;
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
            add-dot-ignore = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "List of dot-ignore files to source ignore patterns from.";
              example = [
                ".gitignore"
                ".kopiaignore"
              ];
            };
            ignore-cache-dirs = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = "Whether to ignore cache directories.";
            };
            max-file-size = lib.mkOption {
              type = with lib.types; nullOr ints.positive;
              default = null;
              description = "Maximum file size (in bytes) to include in backup.";
            };
            one-file-system = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = "Whether to stay within one filesystem when finding files.";
            };
          };

          errorHandling = {
            ignore-file-errors = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = "Whether to ignore errors reading files.";
            };
            ignore-dir-errors = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = "Whether to ignore errors reading directories.";
            };
            ignore-unknown-types = lib.mkOption {
              type = with lib.types; nullOr bool;
              default = null;
              description = "Whether to ignore unknown file types.";
            };
          };

          splitter = lib.mkOption {
            type = with lib.types; nullOr str;
            default = null;
            description = "Splitter algorithm to use.";
          };
        };
      }

    );
  };

  config =
    let
      mkPolicyArgs =
        backup:
        let
          p = backup.policy;

          mkArg =
            flag: value:
            lib.optional (value != null)
              "--${flag}=${if lib.isBool value then lib.boolToString value else toString value}";

          mkListArgs = flag: values: map (v: "--${flag}=${lib.escapeShellArg v}") values;
        in
        lib.concatLists [
          (mkArg "keep-latest" p.retention.keep-latest)
          (mkArg "keep-hourly" p.retention.keep-hourly)
          (mkArg "keep-daily" p.retention.keep-daily)
          (mkArg "keep-weekly" p.retention.keep-weekly)
          (mkArg "keep-monthly" p.retention.keep-monthly)
          (mkArg "keep-annual" p.retention.keep-annual)
          (mkArg "compression" p.compression)
          (mkArg "ignore-cache-dirs" p.files.ignore-cache-dirs)
          (mkArg "max-file-size" p.files.max-file-size)
          (mkArg "one-file-system" p.files.one-file-system)
          (mkArg "ignore-file-errors" p.errorHandling.ignore-file-errors)
          (mkArg "ignore-dir-errors" p.errorHandling.ignore-dir-errors)
          (mkArg "ignore-unknown-types" p.errorHandling.ignore-unknown-types)
          (mkArg "splitter" p.splitter)
          (mkListArgs "add-ignore" p.files.ignore)
          (mkListArgs "add-dot-ignore" p.files.add-dot-ignore)
        ];
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

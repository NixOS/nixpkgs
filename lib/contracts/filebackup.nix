{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types)
    listOf
    nonEmptyListOf
    submodule
    str
    ;

  coerce = x: y: if x != null then x else y;
in
{
  description = ''
    Contract for backing up files.

    The consumer dictates what [folders to backup](#opt-contracts.filebackup.input.sourceDirectories)
    and the provider will execute the backup
    and store a snapshot in a backup repository.
    The exact details on how to configure acces to the repository
    is specific for each provider.

    Every provider exposes a [backup systemd service](#opt-contracts.filebackup.output.backupService)
    and a [script](#opt-contracts.filebackup.output.restoreScript) to list snaphosts
    and restore from a given snapshot.
  '';

  mkConsumerOptions =
    {
      user ? "",
      sourceDirectories ? [ "/var/lib/example" ],
      sourceDirectoriesText ? null,
      excludePatterns ? [ ],
      beforeBackupHooks ? [ ],
      afterBackupHooks ? [ ],
      ...
    }:
    mkOption {
      description = ''
        Consumer part of the [filebackup contract](#opt-contracts.filebackup).
      '';

      default = { };

      type = submodule {
        options = {
          user = mkOption {
            description = ''
              Unix user doing the backup.
            '';
            type = str;
            example = "vaultwarden";
            default = user;
          };

          sourceDirectories = mkOption (
            {
              description = "Directories to backup.";
              type = nonEmptyListOf str;
              example = "/var/lib/vaultwarden";
              default = sourceDirectories;
            }
            # This pattern is clumsy but necessary to support
            # referencing to the config attrset from withing the options' defaults.
            // lib.optionalAttrs (sourceDirectoriesText != null) {
              defaultText = sourceDirectoriesText;
            }
          );

          excludePatterns = mkOption {
            description = "File patterns to exclude.";
            type = listOf str;
            default = excludePatterns;
          };

          beforeBackupHooks = mkOption {
            description = "Hooks to run before backup.";
            type = listOf str;
            default = beforeBackupHooks;
          };

          afterBackupHooks = mkOption {
            description = "Hooks to run after backup.";
            type = listOf str;
            default = afterBackupHooks;
          };
        };
      };
    };

  mkProviderOptions =
    {
      restoreScript ? null,
      restoreScriptText ? null,
      backupService ? null,
      backupServiceText ? null,
    }:
    let
      fallbackRestoreName = "restoreScript";
      fallbackBackupServiceName = "backup.service";
    in
    mkOption {
      description = ''
        Consumer part of the [filebackup contract](#opt-contracts.filebackup).
      '';

      default = { };

      type = submodule {
        options = {
          restoreScript = mkOption (
            {
              description = ''
                Name of script that can restore the given sourceDirectories.

                To list snapshots, run:

                ```bash
                $ ${coerce (coerce restoreScriptText restoreScript) fallbackRestoreName} snapshots
                ```

                To restore a given snapshot, run:

                ```bash
                $ ${coerce (coerce restoreScriptText restoreScript) fallbackRestoreName} restore latest
              '';
              type = str;
            }
            // (
              if (restoreScript != null) then
                {
                  default = restoreScript;
                }
              else
                {
                  example = fallbackRestoreName;
                }
            )
            # This pattern is clumsy but necessary to support
            # referencing to the pkgs attrset from withing the options' defaults.
            // lib.optionalAttrs (restoreScriptText != null) {
              defaultText = restoreScriptText;
            }
          );

          backupService =
            mkOption {
              description = ''
                Name of service backing up the given sourceDirectories.

                Usually, this service will be run at regular intervals thanks to a systemd timer.
                This is dependent on the actual contract provider used.

                It can also be ran manually with:

                ```bash
                $ systemctl start ${coerce (coerce backupServiceText backupServiceText) fallbackBackupServiceName}
                ```
              '';
              type = str;
            }
            // (
              if (backupService != null) then
                {
                  default = backupService;
                }
              else
                {
                  example = fallbackBackupServiceName;
                }
            );
        };
      };
    };
}

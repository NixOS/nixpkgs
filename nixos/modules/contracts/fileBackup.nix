{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types)
    str
    path
    nonEmptyListOf
    listOf
    submodule
    ;
in
{
  contracts.fileBackup = {
    meta = {
      maintainers = [ lib.maintainers.ibizaman ];
      description = ''
        File backup contract where a directory containing
        regular files is to be backed up.
      '';
    };

    input = {
      options.user = mkOption {
        description = ''
          Unix user doing the backups.
        '';
        type = str;
        example = "vaultwarden";
      };

      options.sourceDirectories = mkOption {
        description = "Directories to back up.";
        type = nonEmptyListOf str;
        example = "/var/lib/vaultwarden";
      };

      options.excludePatterns = mkOption {
        description = "File patterns to exclude.";
        type = listOf str;
        default = [ ];
      };

      options.hooks = mkOption {
        description = "Hooks to run around the backup.";
        default = { };
        type = submodule {
          options = {
            beforeBackup = mkOption {
              description = "Hooks to run before backup.";
              type = listOf path;
              default = [ ];
            };

            afterBackup = mkOption {
              description = "Hooks to run after backup.";
              type = listOf path;
              default = [ ];
            };
          };
        };
      };
    };

    output = output: {
      options.restoreScript = mkOption {
        description = ''
          Name of script that can restore the database.
          One can then list snapshots with:

          ```bash
          $ ${output.options.restoreScript.value} snapshots
          ```

          And restore the database with:

          ```bash
          $ ${output.options.restoreScript.value} restore latest
          ```
        '';
        type = path;
      };

      options.backupService = mkOption {
        description = ''
          Name of service backing up the database.

          This script can be ran manually to back up the database:

          ```bash
          $ systemctl start ${output.options.backupService.value}
          ```
        '';
        type = str;
      };
    };

    behaviorTest =
      {
        providerRoot,
        extraModules ? [ ],
      }:
      {
        nodes.machine =
          { config, ... }:
          {
            imports = extraModules;

            options.test = {
              repository = mkOption {
                type = str;
                default = "/opt/repository";
              };
              username = mkOption {
                type = str;
                default = "me";
              };
              sourceDirectories = mkOption {
                type = listOf str;
                default = [
                  "/opt/files/A"
                  "/opt/files/B"
                ];
              };
            };

            config = lib.mkMerge [
              (lib.setAttrByPath providerRoot {
                consumer.input = {
                  inherit (config.test) sourceDirectories;
                  user = config.test.username;
                };
              })
              (lib.mkIf (config.test.username != "root") {
                users.users.${config.test.username} = {
                  isSystemUser = true;
                  group = config.test.username;
                };
                users.groups.${config.test.username} = { };
              })
            ];
          };

        extraPythonPackages = p: [ p.dictdiffer ];

        testScript =
          { nodes, ... }:
          let
            cfg = nodes.machine;
            inherit (lib.getAttrFromPath providerRoot nodes.machine) output;
          in
          ''
            from dictdiffer import diff # type: ignore

            username = "${cfg.test.username}"
            sourceDirectories = [ ${lib.concatMapStringsSep ", " (x: ''"${x}"'') cfg.test.sourceDirectories} ]

            def list_files(dir):
                files_and_content = {}

                files = machine.succeed(f"""find {dir} -type f""").split("\n")[:-1]

                for f in files:
                    content = machine.succeed(f"""cat {f}""").strip()
                    files_and_content[f] = content

                return files_and_content

            def assert_files(dir, files):
                result = list(diff(list_files(dir), files))
                if len(result) > 0:
                    raise Exception("Unexpected files:", result)

            with subtest("Create initial content"):
                for path in sourceDirectories:
                    machine.succeed(f"""
                        mkdir -p {path}
                        echo repo_fileA_1 > {path}/fileA
                        echo repo_fileB_1 > {path}/fileB

                        chown {username}: -R {path}
                        chmod go-rwx -R {path}
                    """)

                for path in sourceDirectories:
                    assert_files(path, {
                        f'{path}/fileA': 'repo_fileA_1',
                        f'{path}/fileB': 'repo_fileB_1',
                    })

            with subtest("First backup in repo"):
                print(machine.succeed("systemctl cat ${output.backupService}"))
                machine.succeed("systemctl start ${output.backupService}")

            with subtest("New content"):
                for path in sourceDirectories:
                    machine.succeed(f"""
                      echo repo_fileA_2 > {path}/fileA
                      echo repo_fileB_2 > {path}/fileB
                      """)

                    assert_files(path, {
                        f'{path}/fileA': 'repo_fileA_2',
                        f'{path}/fileB': 'repo_fileB_2',
                    })

            with subtest("Delete content"):
                for path in sourceDirectories:
                    machine.succeed(f"""rm -r {path}/*""")

                    assert_files(path, {})

            with subtest("Restore initial content from repo"):
                machine.succeed("""${output.restoreScript} restore latest""")

                for path in sourceDirectories:
                    assert_files(path, {
                        f'{path}/fileA': 'repo_fileA_1',
                        f'{path}/fileB': 'repo_fileB_1',
                    })
          '';
      };
  };

  meta.buildDocsInSandbox = false;
}

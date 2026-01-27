{
  lib,
}:
let
  inherit (lib) mkOption types;
in
{
  name,
  providerRoot,
  extraModules ? [ ],
}:
{
  name = "contracts_filebackup_${name}";

  nodes.machine =
    { config, ... }:
    {
      imports = extraModules;

      options.test = {
        repository = mkOption {
          type = types.str;
          default = "/opt/repository";
        };
        username = mkOption {
          type = types.str;
          default = "me";
        };
        sourceDirectories = mkOption {
          type = types.listOf types.str;
          default = [
            "/opt/files/A"
            "/opt/files/B"
          ];
        };
      };

      config = lib.mkMerge [
        (lib.setAttrByPath providerRoot {
          input = {
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
}

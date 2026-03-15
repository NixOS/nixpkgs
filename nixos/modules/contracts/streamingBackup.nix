{ lib, ... }:
let
  inherit (lib) mkOption literalExpression;
  inherit (lib.types) path str;
in
{
  contracts.streamingBackup = {
    meta = {
      maintainers = [ lib.maintainers.ibizaman ];
      description = ''
        Streaming backup contract where what items to back up come from a stream.

        For example, this contract is well suited to back up a database or a tar file.
      '';
    };

    input = {
      options = {
        backupName = mkOption {
          description = "Name of the backup in the repository.";
          type = str;
          example = "postgresql.sql";
        };

        backupCmd = mkOption {
          description = "A bash command that produces the database dump on stdout.";
          type = str;
          example = literalExpression ''
            ''${pkgs.postgresql}/bin/pg_dumpall | ''${pkgs.gzip}/bin/gzip --rsyncable
          '';
        };

        restoreCmd = mkOption {
          description = ''
            A bash command that reads the database dump on stdin and restores the database.
          '';
          type = str;
          example = literalExpression ''
            ''${pkgs.gzip}/bin/gunzip | ''${pkgs.postgresql}/bin/psql postgres
          '';
        };
      };
    };

    output = output: {
      options = {
        restoreScript = mkOption {
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

        backupService = mkOption {
          description = ''
            Name of service backing up the database.

            This script can be ran manually to back up the database:

            ```bash
            $ systemctl start ${(lib.debug.traceValFn lib.attrNames output.config).backupService.value}
            ```
          '';
          type = str;
        };
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
              backupName = mkOption {
                type = str;
                default = "db.bck";
              };
            };

            config = lib.mkMerge [
              (lib.setAttrByPath providerRoot {
                consumer = config.services.postgresql.streamingBackup;
              })
              {
                services.postgresql = {
                  streamingBackup.provider = lib.getAttrFromPath providerRoot;

                  enable = true;
                  ensureDatabases = [
                    config.test.username
                    "testdb"
                  ];
                  ensureUsers = [
                    {
                      name = config.test.username;
                      ensureDBOwnership = true;
                      ensureClauses.login = true;
                    }
                  ];
                };
                test.backupName = "db.bck";
                test.username = config.services.postgresql.superUser;
              }
              (lib.mkIf (config.test.username != "root") {
                users.users.${config.test.username} = {
                  isSystemUser = true;
                  group = config.test.username;
                };
                users.groups.${config.test.username} = { };
              })
            ];
          };

        testScript =
          { nodes, ... }:
          let
            cfg = nodes.machine;
            inherit (lib.getAttrFromPath providerRoot nodes.machine) output;
          in
          ''
            import csv

            start_all()
            machine.wait_for_unit("postgresql.service")
            machine.wait_for_open_port(5432)

            def peer_cmd(cmd, db="testdb"):
                return "sudo -u ${cfg.test.username} psql -U ${cfg.test.username} {db} --csv --command \"{cmd}\"".format(cmd=cmd, db=db)

            def query(query):
                res = machine.succeed(peer_cmd(query))
                return list(dict(l) for l in csv.DictReader(res.splitlines()))

            def cmp_tables(a, b):
                for i in range(max(len(a), len(b))):
                    diff = set(a[i]) ^ set(b[i])
                    if len(diff) > 0:
                        raise Exception(i, diff)

            table = [{'name': 'car', 'count': '1'}, {'name': 'lollipop', 'count': '2'}]

            with subtest("create fixture"):
                machine.succeed(peer_cmd("CREATE TABLE test (name text, count int)"))
                machine.succeed(peer_cmd("INSERT INTO test VALUES ('car', 1), ('lollipop', 2)"))

                res = query("SELECT * FROM test")
                cmp_tables(res, table)

            with subtest("backup"):
                print(machine.succeed("systemctl start ${output.backupService}"))

            with subtest("drop database"):
                print(machine.succeed(peer_cmd("DROP DATABASE testdb", db="postgres")))
                machine.fail(peer_cmd("SELECT * FROM test"))

            with subtest("restore"):
                print(machine.succeed("${output.restoreScript} restore latest"))

            with subtest("check restoration"):
                res = query("SELECT * FROM test")
                cmp_tables(res, table)
          '';
      };
  };

  meta.buildDocsInSandbox = false;
}

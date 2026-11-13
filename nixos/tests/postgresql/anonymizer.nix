{
  runTest,
  genTests,
  ...
}:

let
  makeTestFor =
    package:
    runTest (
      { lib, pkgs, ... }:
      {
        name = "postgresql_anonymizer-${package.name}";
        meta.maintainers = [
          lib.maintainers.leona
          lib.maintainers.osnyx
        ];

        nodes.machine =
          { pkgs, ... }:
          {
            users.users.anon_dumper = {
              isSystemUser = true;
              group = "anon_dumper";
            };
            users.groups.anon_dumper = { };
            services.postgresql = {
              inherit package;
              enable = true;
              extensions = ps: [ ps.anonymizer ];
              settings.shared_preload_libraries = [ "anon" ];
            };
          };

        testScript = ''
          start_all()
          machine.wait_for_unit("multi-user.target")
          machine.wait_for_unit("postgresql.target")

          with subtest("Setup"):
              machine.succeed("sudo -u postgres psql --command 'create database demo'")
              machine.succeed(
                  "sudo -u postgres psql -d demo -f ${pkgs.writeText "init.sql" ''
                    create extension anon cascade;
                    select anon.init();
                    create table player(id serial, name text, points int);
                    insert into player(id,name,points) values (1,'Foo', 23);
                    insert into player(id,name,points) values (2,'Bar',42);
                    security label for anon on column player.name is 'MASKED WITH FUNCTION anon.fake_last_name()';
                    security label for anon on column player.points is 'MASKED WITH VALUE NULL';
                    create role anon_dumper login;
                    alter role anon_dumper set anon.transparent_dynamic_masking = true;
                    security label for anon on role anon_dumper is 'MASKED';
                    grant pg_read_all_data to anon_dumper;
                    create role player_owner;
                    alter table player owner to player_owner;
                    grant select on table anon.last_name to player_owner;
                  ''}"
              )

          def get_player_table_contents():
              return [
                  x.split(',') for x in machine.succeed("sudo -u postgres psql -d demo --csv --command 'select * from player'").splitlines()[1:]
              ]

          def check_anonymized_row(row, id, original_name):
              t.assertEqual(row[0], id)
              t.assertNotIn(row[1], (original_name, "", "\\N"))
              t.assertIn(row[2], ("", "\\N"))

          def find_xsv_in_dump(dump, sep=','):
              """
              Expecting to find pg_dump's COPY block, looking like

                  COPY public.player ...
                  <tab-separated rows, NULL written as \\N>
                  \\.

              in the given dump. Extract the data lines and split by `sep`.
              """

              try:
                  from itertools import dropwhile, takewhile
                  return [x.split(sep) for x in list(takewhile(
                      lambda x: x != "\\.",
                      dropwhile(
                          lambda x: not x.startswith("COPY public.player"),
                          dump.splitlines()
                      )
                  ))[1:]]
              except:
                  print(f"Dump to process: {dump}")
                  raise

          def check_original_data(output):
              t.assertEqual(output[0], ["1", "Foo", "23"])
              t.assertEqual(output[1], ["2", "Bar", "42"])

          def check_anonymized_rows(output):
              check_anonymized_row(output[0], '1', 'Foo')
              check_anonymized_row(output[1], '2', 'Bar')

          with subtest("Check initial state"):
              check_original_data(get_player_table_contents())

          with subtest("Anonymous dumps"):
              check_original_data(find_xsv_in_dump(
                  machine.succeed("sudo -u postgres pg_dump demo"),
                  sep='\t'
              ))
              check_anonymized_rows(find_xsv_in_dump(
                  machine.succeed("sudo -u anon_dumper pg_dump demo --no-security-labels --extension plpgsql"),
                  sep='\t'
              ))

          with subtest("Anonymize"):
              # anon.nosuperuser forbids masking as a superuser
              machine.succeed("sudo -u postgres psql -d demo --command 'set role player_owner; select anon.anonymize_database();'")
              check_anonymized_rows(get_player_table_contents())
        '';
      }
    );
in
genTests {
  inherit makeTestFor;
  filter = _: p: !p.pkgs.anonymizer.meta.broken;
}

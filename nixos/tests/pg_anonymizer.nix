import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "pg_anonymizer";
    meta.maintainers = lib.teams.flyingcircus.members;

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.pg-dump-anon ];
        services.postgresql = {
          enable = true;
          extraPlugins = ps: [ ps.anonymizer ];
          settings.shared_preload_libraries = [ "anon" ];
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("postgresql.service")

      with subtest("Setup"):
          machine.succeed("sudo -u postgres psql --command 'create database demo'")
          machine.succeed(
              "sudo -u postgres psql -d demo -f ${pkgs.writeText "init.sql" ''
                create extension anon cascade;
                select anon.init();
                create table player(id serial, name text, points int);
                insert into player(id,name,points) values (1,'Foo', 23);
                insert into player(id,name,points) values (2,'Bar',42);
                security label for anon on column player.name is 'MASKED WITH FUNCTION anon.fake_last_name();';
                security label for anon on column player.points is 'MASKED WITH VALUE NULL';
              ''}"
          )

      def get_player_table_contents():
          return [
              x.split(',') for x in machine.succeed("sudo -u postgres psql -d demo --csv --command 'select * from player'").splitlines()[1:]
          ]

      def check_anonymized_row(row, id, original_name):
          assert row[0] == id, f"Expected first row to have ID {id}, but got {row[0]}"
          assert row[1] != original_name, f"Expected first row to have a name other than {original_name}"
          assert not bool(row[2]), "Expected points to be NULL in first row"

      def find_xsv_in_dump(dump, sep=','):
          """
          Expecting to find a CSV (for pg_dump_anon) or TSV (for pg_dump) structure, looking like

              COPY public.player ...
              1,Shields,
              2,Salazar,
              \.

          in the given dump (the commas are tabs in case of pg_dump).
                Extract the CSV lines and split by `sep`.
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
          assert output[0] == ['1','Foo','23'], f"Expected first row from player table to be 1,Foo,23; got {output[0]}"
          assert output[1] == ['2','Bar','42'], f"Expected first row from player table to be 2,Bar,42; got {output[1]}"

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
              machine.succeed("sudo -u postgres pg_dump_anon -U postgres -h /run/postgresql -d demo"),
              sep=','
          ))

      with subtest("Anonymize"):
          machine.succeed("sudo -u postgres psql -d demo --command 'select anon.anonymize_database();'")
          check_anonymized_rows(get_player_table_contents())
    '';
  }
)

import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "pg_anonymizer";
  meta.maintainers = lib.teams.flyingcircus.members;

  nodes.machine = {
    services.postgresql = {
      enable = true;
      extraPlugins = ps: [ ps.anonymizer ];
      settings.shared_preload_libraries = "anon";
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

    with subtest("Check initial state"):
        output = get_player_table_contents()
        assert output[0] == ['1','Foo','23'], f"Expected first row from player table to be 1,Foo,23; got {output[0]}"
        assert output[1] == ['2','Bar','42'], f"Expected first row from player table to be 2,Bar,42; got {output[1]}"

    with subtest("Anonymize"):
        machine.succeed("sudo -u postgres psql -d demo --command 'select anon.anonymize_database();'")
        output = get_player_table_contents()

        check_anonymized_row(output[0], '1', 'Foo')
        check_anonymized_row(output[1], '2', 'Bar')
  '';
})

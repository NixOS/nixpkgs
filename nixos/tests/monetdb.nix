import ./make-test-python.nix ({ pkgs, ...} :
  let creds = pkgs.writeText ".monetdb" ''
        user=monetdb
        password=monetdb
      '';
      createUser = pkgs.writeText "createUser.sql" ''
        CREATE USER "voc" WITH PASSWORD 'voc' NAME 'VOC Explorer' SCHEMA "sys";
        CREATE SCHEMA "voc" AUTHORIZATION "voc";
        ALTER USER "voc" SET SCHEMA "voc";
      '';
      credsVoc = pkgs.writeText ".monetdb" ''
        user=voc
        password=voc
      '';
      transaction = pkgs.writeText "transaction" ''
        START TRANSACTION;
        CREATE TABLE test (id int, data varchar(30));
        ROLLBACK;
      '';
      vocData = pkgs.fetchzip {
        url = "https://dev.monetdb.org/Assets/VOC/voc_dump.zip";
        hash = "sha256-sQ5acTsSAiXQfOgt2PhN7X7Z9TZGZtLrPPxgQT2pCGQ=";
      };
      onboardPeople = pkgs.writeText "onboardPeople" ''
        CREATE VIEW onboard_people AS
        SELECT * FROM (
        SELECT 'craftsmen' AS type, craftsmen.* FROM craftsmen
        UNION ALL
        SELECT 'impotenten' AS type, impotenten.* FROM impotenten
        UNION ALL
        SELECT 'passengers' AS type, passengers.* FROM passengers
        UNION ALL
        SELECT 'seafarers' AS type, seafarers.* FROM seafarers
        UNION ALL
        SELECT 'soldiers' AS type, soldiers.* FROM soldiers
        UNION ALL
        SELECT 'total' AS type, total.* FROM total
        ) AS onboard_people_table;
        SELECT type, COUNT(*) AS total
        FROM onboard_people GROUP BY type ORDER BY type;
      '';
      onboardExpected = pkgs.lib.strings.replaceStrings ["\n"] ["\\n"] ''
        +------------+-------+
        | type       | total |
        +============+=======+
        | craftsmen  |  2349 |
        | impotenten |   938 |
        | passengers |  2813 |
        | seafarers  |  4468 |
        | soldiers   |  4177 |
        | total      |  2467 |
        +------------+-------+
      '';
  in {
    name = "monetdb";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ StillerHarpo ];
    };
    nodes.machine.services.monetdb.enable = true;
    testScript = ''
      machine.start()
      machine.wait_for_unit("monetdb")
      machine.succeed("monetdbd create mydbfarm")
      machine.succeed("monetdbd start mydbfarm")
      machine.succeed("monetdb create voc")
      machine.succeed("monetdb release voc")
      machine.succeed("cp ${creds} ./.monetdb")
      assert "hello world" in machine.succeed("mclient -d voc -s \"SELECT 'hello world'\"")
      machine.succeed("mclient -d voc ${createUser}")
      machine.succeed("cp ${credsVoc} ./.monetdb")
      machine.succeed("mclient -d voc ${transaction}")
      machine.succeed("mclient -d voc ${vocData}/voc_dump.sql")
      assert "8131" in machine.succeed("mclient -d voc -s \"SELECT count(*) FROM voyages\"")
      assert "${onboardExpected}" in machine.succeed("mclient -d voc ${onboardPeople}")

  '';
  })

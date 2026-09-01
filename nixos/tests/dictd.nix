{ lib, pkgs, ... }:
{
  name = "dictd";
  meta.maintainers = with lib.maintainers; [
    h7x4
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.dictd = {
        enable = true;
        DBs = with pkgs.dictdDBs; [
          jpn2eng
          eng2jpn
          # A single package bundling several dictionaries; the collector must
          # register every one of them. Regression test for #29149.
          mueller_eng2rus_pkg
        ];
      };
    };

  testScript = ''
    machine.wait_for_unit("dictd.service")
    machine.wait_for_open_port(2628)

    machine.succeed("dict --serverinfo | grep 'On machine: up'")
    machine.succeed("dict --dbs | grep '${pkgs.dictdDBs.jpn2eng.name}'")
    machine.succeed("dict -d '${pkgs.dictdDBs.jpn2eng.name}' 例え | grep example")
    machine.succeed("dict -d '${pkgs.dictdDBs.eng2jpn.name}' example | grep 例え")

    # The bundled mueller-eng-rus package ships multiple databases; check that
    # each one was registered and is queryable.
    machine.succeed("dict --dbs | grep mueller-base")
    machine.succeed("dict --dbs | grep mueller-abbrev")
    machine.succeed("dict -d mueller-base time")
  '';
}

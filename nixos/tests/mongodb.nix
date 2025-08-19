# This test starts mongodb and runs a query using mongo shell
{ config, lib, ... }:
let
  # required for test execution on darwin
  pkgs = config.node.pkgs;
  testQuery = pkgs.writeScript "nixtest.js" ''
    db.greetings.insertOne({ "greeting": "hello" });
    print(db.greetings.findOne().greeting);
  '';
  mongoshExe = lib.getExe pkgs.mongosh;
in
{
  name = "mongodb";
  meta.maintainers = with pkgs.lib.maintainers; [
    offline
    phile314
    niklaskorz
  ];

  nodes.mongodb = {
    services.mongodb.enable = true;
  };

  testScript = ''
    start_all()

    with subtest("start mongodb"):
        mongodb.wait_for_unit("mongodb.service")
        mongodb.wait_for_open_port(27017)

    with subtest("insert and find a document"):
        result = mongodb.succeed("${mongoshExe} ${testQuery}")
        print("Test output:", result)
        assert result.strip() == "hello"
  '';
}

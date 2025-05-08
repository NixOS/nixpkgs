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
  rootPw = "notagoodpw";
in
{
  name = "mongodb";
  meta.maintainers = with pkgs.lib.maintainers; [
    bluescreen303
    offline
    phile314
    niklaskorz
  ];

  nodes.mongodb =
    { config, ... }:
    let
      mongodKeyFileEtcPath = "mongod.keyFile";
    in
    {
      environment.etc."${mongodKeyFileEtcPath}" = {
        source = pkgs.runCommand "keyfile" { } ''
          ${lib.getExe pkgs.openssl} rand -base64 756 > $out
        '';
        mode = "0400";
        user = config.services.mongodb.user;
      };

      services.mongodb = {
        enable = true;
        enableAuth = true;
        replSetName = "rs0";
        initialRootPasswordFile = builtins.toFile "pw" rootPw;
        extraConfig = ''
          security.keyFile: /etc/${mongodKeyFileEtcPath}
        '';
        initialScript = builtins.toFile "initial.js" ''
          rs.initiate()
        '';
      };
    };

  testScript = ''
    start_all()

    with subtest("start mongodb"):
        mongodb.wait_for_unit("mongodb.service")
        mongodb.wait_for_open_port(27017)

    with subtest("insert and find a document"):
        result = mongodb.succeed("${mongoshExe} -u root -p ${rootPw} ${testQuery}")
        print("Test output:", result)
        assert result.strip() == "hello"
  '';

}

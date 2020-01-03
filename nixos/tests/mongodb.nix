# This test start mongodb, runs a query using mongo shell

import ./make-test-python.nix ({ pkgs, ...} : let
  testQuery = pkgs.writeScript "nixtest.js" ''
    db.greetings.insert({ "greeting": "hello" });
    print(db.greetings.findOne().greeting);
  '';
in {
  name = "mongodb";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bluescreen303 offline cstrahan rvl phile314 ];
  };

  nodes = {
    one =
      { ... }:
        {
          services = {
           mongodb.enable = true;
           mongodb.enableAuth = true;
           mongodb.initialRootPassword = "root";
           mongodb.initialScript = pkgs.writeText "mongodb_initial.js" ''
             db = db.getSiblingDB("nixtest");
             db.createUser({user:"nixtest",pwd:"nixtest",roles:[{role:"readWrite",db:"nixtest"}]});
           '';
           mongodb.extraConfig = ''
             # Allow starting engine with only a small virtual disk
             storage.journal.enabled: false
             storage.mmapv1.smallFiles: true
           '';
          };
        };
    };

  testScript = ''
    start_all()
    one.wait_for_unit("mongodb.service")
    one.succeed(
        "mongo -u nixtest -p nixtest nixtest ${testQuery} | grep -q hello"
    )
  '';
})

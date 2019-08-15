# This test start mongodb, runs a query using mongo shell

import ./make-test-python.nix ({ pkgs, ...} : let
  testQuery = pkgs.writeScript "nixtest.js" ''
    db.greetings.insert({ "greeting": "hello" });
    print(db.greetings.findOne().greeting);
  '';

  mongodbNode = mdbPackage: {...}: {
    services = {
      mongodb.enable = true;
      mongodb.package = mdbPackage;
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

  runTest = node: ''
         ${node}->start;
         ${node}->waitForUnit("mongodb.service");
         ${node}->succeed("mongo -u nixtest -p nixtest nixtest ${testQuery}") =~ /hello/ or die;
         ${node}->shutdown;
  '';


in {
  name = "mongodb";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bluescreen303 offline cstrahan rvl phile314 ];
  };

  nodes = {
    v3_4 = mongodbNode pkgs.mongodb-3_4;
    v3_6 = mongodbNode pkgs.mongodb-3_6;
    v4_0 = mongodbNode pkgs.mongodb-4_0;
  };

  testScript = runTest "$v3_4" +
    runTest "$v3_6" +
    runTest "$v4_0";
})

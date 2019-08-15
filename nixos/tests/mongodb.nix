# This test start mongodb, runs a query using mongo shell

import ./make-test-python.nix ({ pkgs, ...} : let
  testQuery = pkgs.writeScript "nixtest.js" ''
    db.greetings.insert({ "greeting": "hello" });
    print(db.greetings.findOne().greeting);
  '';

  runTest = mdbPackage: {...}: {
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



in {
  name = "mongodb";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bluescreen303 offline cstrahan rvl phile314 ];
  };

  nodes = {
    v3_4 = runTest pkgs.mongodb-3_4;
    v3_6 = runTest pkgs.mongodb-3_6;
    v4_0 = runTest pkgs.mongodb-4_0;
  };

  testScript = ''
         $v3_4->start;
         $v3_4->waitForUnit("mongodb.service");
         $v3_4->succeed("mongo -u nixtest -p nixtest nixtest ${testQuery}") =~ /hello/ or die;
         $v3_4->shutdown;

         $v3_6->start;
         $v3_6->waitForUnit("mongodb.service");
         $v3_6->succeed("mongo -u nixtest -p nixtest nixtest ${testQuery}") =~ /hello/ or die;
         $v3_6->shutdown;

         $v4_0->start;
         $v4_0->waitForUnit("mongodb.service");
         $v4_0->succeed("mongo -u nixtest -p nixtest nixtest ${testQuery}") =~ /hello/ or die;
         $v4_0->shutdown;
  '';
})

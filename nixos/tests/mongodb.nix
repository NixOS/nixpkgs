# This test start mongodb, runs a query using mongo shell

import ./make-test.nix ({ pkgs, ... }:
  let
    testQuery = pkgs.writeScript "nixtest.js" ''
      db.greetings.insert({ "greeting": "hello" });
      print(db.greetings.findOne().greeting);
    '';

    runMongoDBTest = pkg: ''
      $node->execute("(rm -rf data || true) && mkdir data");
      $node->execute("${pkg}/bin/mongod --fork --logpath logs --dbpath data");
      $node->waitForOpenPort(27017);

      $node->succeed("mongo ${testQuery}") =~ /hello/ or die;

      $node->execute("${pkg}/bin/mongod --shutdown --dbpath data");
      $node->waitForClosedPort(27017);
    '';

  in {
    name = "mongodb";
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ bluescreen303 offline cstrahan rvl phile314 ];
    };

    nodes = {
      node = {...}: {
        environment.systemPackages = with pkgs; [
#          mongodb-3_4
          mongodb-3_6
          mongodb-4_0
        ];
      };
    };

    testScript = "$node->start;" 
#      + runMongoDBTest pkgs.mongodb-3_4
      + runMongoDBTest pkgs.mongodb-3_6 
      + runMongoDBTest pkgs.mongodb-4_0
      + "$node->shutdown;";
  })

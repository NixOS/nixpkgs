# This test start mongodb, runs a query using mongo shell

import ./make-test-python.nix ({ pkgs, ... }:
  let
    testQuery = pkgs.writeScript "nixtest.js" ''
      db.greetings.insert({ "greeting": "hello" });
      print(db.greetings.findOne().greeting);
    '';

    runMongoDBTest = pkg: ''
      node.execute("(rm -rf data || true) && mkdir data")
      node.execute(
          "${pkg}/bin/mongod --fork --logpath logs --dbpath data"
      )
      node.wait_for_open_port(27017)

      assert "hello" in node.succeed(
          "${pkg}/bin/mongo ${testQuery}"
      )

      node.execute(
          "${pkg}/bin/mongod --shutdown --dbpath data"
      )
      node.wait_for_closed_port(27017)
    '';

  in {
    name = "mongodb";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ bluescreen303 offline phile314 ];
    };

    nodes = {
      node = {...}: {
        environment.systemPackages = with pkgs; [
          mongodb-5_0
        ];
      };
    };

    testScript = ''
      node.start()
    ''
      + runMongoDBTest pkgs.mongodb-5_0
      + ''
        node.shutdown()
      '';
  })

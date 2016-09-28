# This test start mongodb, runs a query using mongo shell

import ./make-test.nix ({ pkgs, ...} : let
  testQuery = pkgs.writeScript "nixtest.js" ''
    db.greetings.insert({ "greeting": "hello" });
    print(db.greetings.findOne().greeting);
  '';
in {
  name = "mongodb";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bluescreen303 offline wkennington cstrahan rvl ];
  };

  nodes = {
    one =
      { config, pkgs, ... }:
        {
          services = {
           mongodb.enable = true;
           mongodb.extraConfig = ''
             # Allow starting engine with only a small virtual disk
             storage.journal.enabled: false
             storage.mmapv1.smallFiles: true
           '';
          };
        };
    };

  testScript = ''
    startAll;
    $one->waitForUnit("mongodb.service");
    $one->succeed("mongo nixtest ${testQuery}") =~ /hello/ or die;
  '';
})

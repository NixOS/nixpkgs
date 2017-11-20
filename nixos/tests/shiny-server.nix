# verifies:
#   1. shiny-server is brought up and responds to requests

import ./make-test.nix ({pkgs, ...} : {
  name = "shiny-server";
  meta = {
    maintainers = with pkgs.stdenv.lib.maintainers; [ orbekk ];
  };

  machine =
    { config, pkgs, lib, ... }:
    {
      services.shiny-server.enable = true;
      services.shiny-server.port = 8080;
    };

  testScript = ''
    $machine->waitForUnit("shiny-server.service");
    $machine->waitForOpenPort(8080);
    $machine->waitUntilSucceeds("curl http://localhost:8080/");
  '';
})

import ./make-test.nix ({ lib, ... }:

with lib;

rec {
  name = "sonarr";
  meta.maintainers = with maintainers; [ etu ];

  nodes.machine =
    { pkgs, ... }:
    { services.sonarr.enable = true; };

  testScript = ''
    $machine->waitForUnit('sonarr.service');
    $machine->waitForOpenPort('8989');
    $machine->succeed("curl --fail http://localhost:8989/");
  '';
})

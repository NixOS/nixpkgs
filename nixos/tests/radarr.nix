import ./make-test.nix ({ lib, ... }:

with lib;

rec {
  name = "radarr";
  meta.maintainers = with maintainers; [ etu ];

  nodes.machine =
    { pkgs, ... }:
    { services.radarr.enable = true; };

  testScript = ''
    $machine->waitForUnit('radarr.service');
    $machine->waitForOpenPort('7878');
    $machine->succeed("curl --fail http://localhost:7878/");
  '';
})

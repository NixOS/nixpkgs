import ./make-test.nix ({ lib, ... }:

with lib;

rec {
  name = "lidarr";
  meta.maintainers = with maintainers; [ etu ];

  nodes.machine =
    { pkgs, ... }:
    { services.lidarr.enable = true; };

  testScript = ''
    $machine->waitForUnit('lidarr.service');
    $machine->waitForOpenPort('8686');
    $machine->succeed("curl --fail http://localhost:8686/");
  '';
})

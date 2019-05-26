import ./make-test.nix ({ lib, ... }:

with lib;

rec {
  name = "jackett";
  meta.maintainers = with maintainers; [ etu ];

  nodes.machine =
    { pkgs, ... }:
    { services.jackett.enable = true; };

  testScript = ''
    $machine->waitForUnit('jackett.service');
    $machine->waitForOpenPort('9117');
    $machine->succeed("curl --fail http://localhost:9117/");
  '';
})

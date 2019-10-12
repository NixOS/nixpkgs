import ./make-test.nix ({ lib, ...}:

{
  name = "shiori";
  meta.maintainers = with lib.maintainers; [ minijackson ];

  machine =
    { ... }:
    { services.shiori.enable = true; };

  testScript = ''
    $machine->waitForUnit('shiori.service');
    $machine->waitForOpenPort('8080');
    $machine->succeed("curl --fail http://localhost:8080/");
    $machine->succeed("curl --fail --location http://localhost:8080/ | grep -qi shiori");
  '';
})

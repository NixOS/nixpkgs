import ./make-test.nix ({ lib, ...}:

{
  name = "jellyfin";
  meta.maintainers = with lib.maintainers; [ minijackson ];

  machine =
    { ... }:
    { services.jellyfin.enable = true; };

  testScript = ''
    $machine->waitForUnit('jellyfin.service');
    $machine->waitForOpenPort('8096');
    $machine->succeed("curl --fail http://localhost:8096/");
  '';
})

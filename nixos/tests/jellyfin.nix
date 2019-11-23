import ./make-test-python.nix ({ lib, ...}:

{
  name = "jellyfin";
  meta.maintainers = with lib.maintainers; [ minijackson ];

  machine =
    { ... }:
    { services.jellyfin.enable = true; };

  testScript = ''
    machine.wait_for_unit("jellyfin.service")
    machine.wait_for_open_port(8096)
    machine.succeed("curl --fail http://localhost:8096/")
  '';
})

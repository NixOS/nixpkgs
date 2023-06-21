import ./make-test-python.nix ({ lib, ... }:

{
  name = "autobrr";
  meta.maintainers = with lib.maintainers; [ etu ];

  nodes.machine =
    { pkgs, ... }:
    { services.autobrr.enable = true; };

  testScript = ''
    machine.wait_for_unit("autobrr.service")
    machine.wait_for_open_port(7474)
    machine.succeed("curl --fail http://localhost:7474/")
  '';
})

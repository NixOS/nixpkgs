import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "prowlarr";
  meta.maintainers = with maintainers; [ jdreaver ];

  nodes.machine =
    { pkgs, ... }:
    { services.prowlarr.enable = true; };

  testScript = ''
    machine.wait_for_unit("prowlarr.service")
    machine.wait_for_open_port(9696)
    machine.succeed("curl --fail http://localhost:9696/")
  '';
})

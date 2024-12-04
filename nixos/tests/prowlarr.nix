import ./make-test-python.nix ({ lib, ... }:

{
  name = "prowlarr";
  meta.maintainers = with lib.maintainers; [ jdreaver ];

  nodes.machine =
    { pkgs, ... }:
    { services.prowlarr.enable = true; };

  testScript = ''
    machine.wait_for_unit("prowlarr.service")
    machine.wait_for_open_port(9696)
    response = machine.succeed("curl --fail http://localhost:9696/")
    assert '<title>Prowlarr</title>' in response, "Login page didn't load successfully"
    machine.succeed("[ -d /var/lib/prowlarr ]")
  '';
})
